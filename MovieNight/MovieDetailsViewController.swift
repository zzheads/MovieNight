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
    var credits: Credits?
    
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
    
    var creditsLabel: UILabel? {
        guard let credits = self.credits else {
            return nil
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .white
        label.numberOfLines = 0
        var castText = "Cast: \n"
        let maxLines = credits.cast.count > 5 ? 5 : credits.cast.count
        for i in 0...maxLines {
             castText += credits.cast[i].description + "\n"
        }
        label.text = castText
        return label
    }
    
    var descriptionLabel: UILabel? {
        guard let movie = self.movie else {
            return nil
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Released: \(movie.release_date)\n "
        return label
    }
    
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
        let poster = self.poster
        else {
            return
        }
        
        let width = CGFloat(185)
        let height = CGFloat(185/0.777)
        
        self.view.addSubview(poster)
        NSLayoutConstraint.activate([
            poster.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            poster.widthAnchor.constraint(equalToConstant: width),
            poster.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: margin),
            poster.heightAnchor.constraint(equalToConstant: height)
            ])
        
        guard let creditsLabel = self.creditsLabel else {
            return
        }
        self.view.addSubview(creditsLabel)
        NSLayoutConstraint.activate([
            creditsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin),
            creditsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin),
            creditsLabel.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: margin),
            creditsLabel.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -margin),
            ])
    }
}
