//
//  ViewController.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import UIKit

fileprivate let SLIDER_MAX: Int = 100
fileprivate let NUMBER_SLIDERS = 4

class SelectWeightsViewController: UIViewController {
    
    let delegateModifyPrefs: (Weights?, [Genre]?, [Actor]?, UIActivityIndicatorView) -> Void
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg-iphone6.png"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var sliders: [UISlider] = []
    
    lazy var labels: [UILabel] = []
    
    lazy var titles = ["Genre", "Actor", "New", "Popularity"]
    
    lazy var doneBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(sender:)))
        return button
    }()
    
    lazy var progress: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.color = AppColors.LightBlue.color
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.isHidden = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    init(delegate: @escaping (Weights?, [Genre]?, [Actor]?, UIActivityIndicatorView) -> Void) {
        self.delegateModifyPrefs = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Watchers weights"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        self.view.addSubview(self.backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundImage.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
        
        self.view.addSubview(self.progress)
        NSLayoutConstraint.activate([
            self.progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.progress.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        
        for i in 0..<NUMBER_SLIDERS {
            
            let yOffset = CGFloat((i + 1) * 80)
            
            let label = UILabel()
            label.textColor = AppColors.Rose.color
            label.font = UIFont.boldSystemFont(ofSize: 16)
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                label.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: yOffset - 20),
                ])
            
            let slider = UISlider()
            self.view.addSubview(slider)
            slider.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                slider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                slider.widthAnchor.constraint(equalToConstant: 200),
                slider.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: yOffset)
                ])
            slider.minimumValue = 0.0
            slider.maximumValue = Float(SLIDER_MAX)
            slider.setValue(Float(SLIDER_MAX) / Float(NUMBER_SLIDERS), animated: true)
            slider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
            slider.tintColor = AppColors.Rose.color
            //slider.setThumbImage(#imageLiteral(resourceName: "appicon"), for: .normal)
            
            self.labels.append(label)
            self.sliders.append(slider)
        }
        self.updateLabels()
        
    }
    
    @objc func sliderChanged(sender: UISlider) {
        var total: Int = 0
        let numberOfSliders = self.sliders.count
        
        for i in 0..<self.sliders.count {
            let slider = self.sliders[i]
            total += Int(slider.value)
        }
        if (total > SLIDER_MAX) {
            let diff: Int = total - SLIDER_MAX
            let minusForEach: Int = diff / Int(numberOfSliders - 1)
            for slider in self.sliders {
                if (slider != sender) {
                    slider.setValue(Float(Int(slider.value) - minusForEach), animated: true)
                }
            }
        }
        if (total < SLIDER_MAX) {
            let diff: Int = SLIDER_MAX - total
            let plusForEach: Int = diff / Int(numberOfSliders - 1)
            for slider in self.sliders {
                if (slider != sender) {
                    slider.setValue(Float(Int(slider.value) + plusForEach), animated: true)
                }
            }
        }
        self.updateLabels()
    }
    
    func updateLabels() {
        for i in 0..<self.sliders.count {
            let label = self.labels[i]
            let slider = self.sliders[i]
            label.text = String(format: "%@ = %.0f", self.titles[i], slider.value)
        }
    }
    
    func donePressed(sender: UIBarButtonItem) {
        let weightGenre = Int(self.sliders[0].value)
        let weightActor = Int(self.sliders[1].value)
        let weightNew = Int(self.sliders[2].value)
        let weightPopularity = Int(self.sliders[3].value)
        
        let weights = Weights(weightGenre: weightGenre, weightActor: weightActor, weightNew: weightNew, weightPopularity: weightPopularity)
        
        self.delegateModifyPrefs(weights, nil, nil, self.progress)
        
        let selectGenresController = SelectGenresViewController(delegate: self.delegateModifyPrefs)
        self.navigationController?.pushViewController(selectGenresController, animated: true)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            let weightGenre = Int(self.sliders[0].value)
            let weightActor = Int(self.sliders[1].value)
            let weightNew = Int(self.sliders[2].value)
            let weightPopularity = Int(self.sliders[3].value)
            
            let weights = Weights(weightGenre: weightGenre, weightActor: weightActor, weightNew: weightNew, weightPopularity: weightPopularity)
            self.delegateModifyPrefs(weights, nil, nil, self.progress)
        }
    }
    
}
