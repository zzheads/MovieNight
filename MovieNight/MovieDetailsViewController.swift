//
//  MovieDetailsViewController.swift
//  MovieNight
//
//  Created by Alexey Papin on 15.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation
import UIKit

fileprivate let margin = CGFloat(8)

class MovieDetailsViewController: UIViewController {
    
    let movieId: Int
    let watchers: [Watcher]
    let apiClient = ResourceAPIClient()
    var selectedActors: [Actor] = []
    
    var config: Configuration?
    var movie: Movie?
    var credits: Credits? {
        didSet {
            guard let credits = self.credits else {
                return
            }
            var result: [String: String] = [:]
            for cast in credits.cast {
                let name = cast.name
                let character = cast.character
                result.updateValue(character, forKey: name)
            }
            self.castDict = result
        }
    }
    
    var castDict: [String: String]?
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg-iphone6.png"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()    
    
    var poster: UIImageView? {
        guard
            let config = self.config,
            let movie = self.movie
            else {
            return nil
        }
        let imageView = UIImageView()
        let path = config.images.secure_base_url + config.images.poster_sizes[2] + movie.poster_path
        imageView.downloadedFrom(link: path)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    lazy var creditsCharacter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var descriptionLabel: UILabel? {
        guard
            let movie = self.movie,
            let credits = self.credits
            else {
            return nil
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        
        var text = "Released: \(movie.release_date)\n"
        if let directorName = credits.directorName {
            text += "Director: \(directorName)\n"
        }
        if let screenplayName = credits.screenplayName {
            text += "Screenplay: \(screenplayName)\n"
        }
        if let producerName = credits.producerName {
            text += "Producer: \(producerName)\n"
        }
        text += String.init(format: "Popularity: %.2f\n", movie.popularity)
        text += String.init(format: "Budget: $%d\n", movie.budget)
        text += String.init(format: "Revenue: $%d\n", movie.revenue)
        
        label.text = text
        return label
    }
    
    lazy var castLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Cast:"
        return label
    }()
    
    var overviewLabel: UILabel? {
        guard
            let movie = self.movie
            else {
                return nil
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = movie.overview
        return label
    }
    
    lazy var castPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
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
    
    init(movieId: Int, watchers: [Watcher]) {
        self.movieId = movieId
        self.watchers = watchers
        for watcher in watchers {
            if let actors = watcher.actors {
                for actor in actors {
                    self.selectedActors.append(actor)
                }
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movie"
        self.navigationController?.toolbar.barStyle = .blackOpaque
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
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
        
        self.progress.startAnimating()
        self.apiClient.fetchResource(resource: ResourceType.Configuration, resourceClass: Configuration.self) { result in
            switch result {
            case .Success(let config):
                self.config = config
                self.apiClient.fetchResource(resource: ResourceType.Movie(.Details(id: self.movieId)), resourceClass: Movie.self) { result in
                    switch result {
                    case .Success(let movie):
                        self.movie = movie
                        self.navigationItem.title = "\(movie.title)"
                        self.apiClient.fetchResource(resource: .Movie(.Credits(id: self.movieId)), resourceClass: Credits.self) { result in
                            switch result {
                            case .Success(let credits):
                                self.credits = credits
                                self.showAll()
                                self.progress.stopAnimating()
                            case .Failure(let error):
                                print("Can not fetch credits: \(error.localizedDescription)")
                            }
                        }
                    case .Failure(let error):
                        print("Can not fetch configuration: \(error.localizedDescription)")
                        break
                    }
                }
                
            case .Failure(let error):
                print("Can not fetch movie: \(error.localizedDescription)")
                break
            }
            
        }
        
    }
    
    func showAll() {
        guard
        let poster = self.poster,
        let descriptionLabel = self.descriptionLabel,
        let overviewLabel = self.overviewLabel
        else {
            return
        }
        
        self.view.addSubview(poster)
        NSLayoutConstraint.activate([
            poster.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            poster.rightAnchor.constraint(equalTo: self.view.centerXAnchor),
            poster.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: margin),
            poster.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        
        self.view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: margin),
            descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            descriptionLabel.topAnchor.constraint(equalTo: poster.topAnchor)
            ])
        
        self.view.addSubview(overviewLabel)
        NSLayoutConstraint.activate([
            overviewLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            overviewLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            overviewLabel.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: margin),
            overviewLabel.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -UIScreen.main.bounds.size.height / 4)
            ])
        
        self.view.addSubview(castLabel)
        NSLayoutConstraint.activate([
            castLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            castLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: margin),
            castLabel.heightAnchor.constraint(equalToConstant: castLabel.font.lineHeight)
            ])
        
        self.view.addSubview(self.castPicker)
        NSLayoutConstraint.activate([
            self.castPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            self.castPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            self.castPicker.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: margin),
            self.castPicker.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -margin)
            ])
        
    }
}

extension MovieDetailsViewController: UIPickerViewDataSource {
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let castDict = self.castDict else {
            return 0
        }
        return castDict.keys.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return UIFont.boldSystemFont(ofSize: 14).lineHeight
    }

}

extension MovieDetailsViewController: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if view != nil {
            return view!
        }
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 14)
        guard let castDict = self.castDict else {
            return view
        }
        let name = [String](castDict.keys)[row]
        var title: String
        var color: UIColor
        switch component {
        case 0:
            title = name
            color = .white
            if self.selectedActors.contains(where: { $0.name.uppercased() == name.uppercased() }) {
                color = AppColors.Rose.color
            }
        case 1:
            guard let character = castDict[name] else {
                title = "Not found character for \(name)"
                color = .red
                break
            }
            title = character
            color = .white
        default:
            return view
        }
        view.textColor = color
        view.text = title
        view.textAlignment = .center
        return view
    }

    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            pickerView.selectRow(row, inComponent: 1, animated: true)
        case 1:
            pickerView.selectRow(row, inComponent: 0, animated: true)
        default:
            break
        }
    }
    
}
