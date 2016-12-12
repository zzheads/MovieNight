//
//  ViewController.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import UIKit

fileprivate let SLIDER_MAX: Float = 100
fileprivate let NUMBER_SLIDERS = 4

class ViewController: UIViewController {
    
    var currentWatcher = 0
    
    var watchers: [Watcher] = [Watcher(name: ""), Watcher(name: "")] {
        didSet {
            for i in 0..<self.watchers.count {
                let watcher = self.watchers[i]
                let button = self.buttons[i]
                
                if watcher.weights == nil && watcher.preferences == nil {
                    button.setBackgroundImage(#imageLiteral(resourceName: "bubble-empty"), for: .normal)
                } else {
                    button.setBackgroundImage(#imageLiteral(resourceName: "bubble-selected"), for: .normal)
                }
            }
        }
    }
    
    lazy var clearBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearPressed(sender:)))
        return button
    }()
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg-iphone6.png"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var buttons: [UIButton] = {
        var buttons: [UIButton] = []
        for _ in 0...1 {
        let button = UIButton(type: .system)
            button.setBackgroundImage(#imageLiteral(resourceName: "bubble-empty"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movie Night"
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.tintColor = AppColors.Rose.color
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = clearBarButton
        
        self.view.addSubview(self.backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundImage.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
        
        for i in 0..<self.buttons.count {
            let button = self.buttons[i]
            let xMargin = i == 0 ? UIScreen.main.bounds.size.width / 4 : UIScreen.main.bounds.size.width * 3 / 4
            self.view.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: xMargin),
                button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                ])
        }
        
    }
    
    func modifyPrefs(weights: Weights?, genreIds: [Int]?, actorIds: [Int]?) {
        if let weights = weights {
            self.watchers[currentWatcher].weights = weights
        }
        if let genreIds = genreIds {
            if self.watchers[currentWatcher].preferences != nil {
                self.watchers[currentWatcher].preferences?.genreIds = genreIds
            } else {
                self.watchers[currentWatcher].preferences = Preferences(genreIds: genreIds, actorIds: [])
            }
        }
        if let actorIds = actorIds {
            if self.watchers[currentWatcher].preferences != nil {
                self.watchers[currentWatcher].preferences?.actorIds = actorIds
            } else {
                self.watchers[currentWatcher].preferences = Preferences(genreIds: [], actorIds: actorIds)
            }
        }
    }
    
    func buttonPressed(sender: UIButton) {
        for i in 0..<self.buttons.count {
            let button = self.buttons[i]
            if button == sender {
                currentWatcher = i
            }
        }
        
        let selectWeightsController = SelectWeightsViewController(delegate: modifyPrefs)
        self.navigationController?.pushViewController(selectWeightsController, animated: true)
    }
    
    func clearPressed(sender: UIBarButtonItem) {
        for i in 0..<self.watchers.count {
            self.watchers[i].preferences = nil
        }
    }
}

