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
    let apiClient = ResourceAPIClient()
    
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
        text += "\n"
        text += "Overview: \(movie.overview)"
        
        label.text = text
        return label
    }
    
    lazy var castPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    init(movieId: Int) {
        self.movieId = movieId
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
        let descriptionLabel = self.descriptionLabel
        else {
            return
        }
        
        let width = CGFloat(185)
        let height = CGFloat(185/0.777)
        
        self.view.addSubview(poster)
        NSLayoutConstraint.activate([
            poster.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            poster.widthAnchor.constraint(equalToConstant: width),
            poster.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: margin * 2),
            poster.heightAnchor.constraint(equalToConstant: height)
            ])
        
        self.view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: margin),
            descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            descriptionLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: margin),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -margin)
            ])
        
        self.view.addSubview(self.castPicker)
        NSLayoutConstraint.activate([
            self.castPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            self.castPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            self.castPicker.heightAnchor.constraint(equalToConstant: 15 * margin),
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
            color = AppColors.Rose.color
        case 1:
            guard let character = castDict[name] else {
                title = "Not found character for \(name)"
                color = .red
                break
            }
            title = character
            color = AppColors.Blue.color
        default:
            return view
        }
        view.textColor = color
        view.text = title
        view.textAlignment = .left
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
