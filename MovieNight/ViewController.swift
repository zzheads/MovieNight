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
    
    var watchers: [Watcher] = [Watcher(name: "Watcher 1"), Watcher(name: "Watcher 2")] {
        didSet {
            for i in 0..<self.watchers.count {
                let watcher = self.watchers[i]
                let button = self.buttons[i]
                                
                if watcher.weights == nil && watcher.genres == nil && watcher.actors == nil {
                    button.setBackgroundImage(#imageLiteral(resourceName: "bubble-empty"), for: .normal)
                } else {
                    button.setBackgroundImage(#imageLiteral(resourceName: "bubble-selected"), for: .normal)
                }
            }
            if watchers.allSet {
                showResultsButton.isHidden = false
            } else {
                showResultsButton.isHidden = true
            }
        }
    }
    
    lazy var showResultsButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitle("View Results", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.Bordo.color
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(viewResults), for: .touchUpInside)
        return button
    }()
    
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
        
        self.view.addSubview(self.showResultsButton)
        NSLayoutConstraint.activate([
            showResultsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            showResultsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            showResultsButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -16),
            showResultsButton.heightAnchor.constraint(equalToConstant: 80)
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
    
    func modifyPrefs(weights: Weights?, genres: [Genre]?, actors: [Actor]?) {
        let apiClient = ResourceAPIClient()
        if let weights = weights {
            self.watchers[currentWatcher].weights = weights
        }
        if let genres = genres {
            self.watchers[currentWatcher].genres = genres
            for genre in genres {
                apiClient.fetchPages(resourceType: ResourceType.Genre(.Movies(id: genre.id, pages: 10)), resourceClass: MovieHead.self) { movieHeads in
                    if (self.watchers[self.currentWatcher].movieIdsByGenres == nil) {
                        self.watchers[self.currentWatcher].movieIdsByGenres = []
                    }
                    for movieHead in movieHeads {
                        self.watchers[self.currentWatcher].movieIdsByGenres?.append(movieHead.id)
                    }
                }
            }
        }
        if let actors = actors {
            self.watchers[currentWatcher].actors = actors
            for actor in actors {
                apiClient.fetchResource(resource: ResourceType.Person(.MovieCredits(id: actor.id)), resourceClass: MovieCredits.self) { result in
                    switch result {
                    case .Success(let movieCredits):
                        for movieCast in movieCredits.movieCast {
                            if (self.watchers[self.currentWatcher].movieIdsByActors == nil) {
                                self.watchers[self.currentWatcher].movieIdsByActors = []
                            }
                            self.watchers[self.currentWatcher].movieIdsByActors?.append(movieCast.id)
                        }
                    case .Failure(let error):
                        print("Can not fetch credits for actor(\(actor.name)): \(error.localizedDescription)")
                        break
                    }
                }
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
    
    func viewResults() {
        let viewResultsController = ViewResultsController(watchers: self.watchers)
        self.navigationController?.pushViewController(viewResultsController, animated: true)
    }
    
    func clearPressed(sender: UIBarButtonItem) {
        for i in 0..<self.watchers.count {
            watchers[i].weights = nil
            watchers[i].genres = nil
            watchers[i].actors = nil
            watchers[i].movieIdsByActors = nil
            watchers[i].movieIdsByGenres = nil
        }
    }
}

