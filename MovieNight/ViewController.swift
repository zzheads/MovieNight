//
//  ViewController.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let apiClient =  ResourceAPIClient()
        apiClient.fetchResource(resource: ResourceType.Configuration, resourceClass: Configuration.self) { result in
            switch result {
            case .Success(let config):
                print(config)
                apiClient.fetchPages(resourceType: ResourceType.Movie(.NowPlaying(pages: 1)), resourceClass: Movie.self) { movies in
                    for movie in movies {
                        apiClient.fetchResource(resource: ResourceType.Movie(.Images(id: movie.id)), resourceClass: Image.self) { result in
                            switch result {
                            case .Success(let image):
                                if let posters = image.posters {
                                    for poster in posters {
                                        let path = config.images.base_url + config.images.poster_sizes.last! + poster.file_path
                                        print("Posters of \(movie.title.uppercased()): \(path)")
                                    }
                                }
                            case .Failure(let error):
                                print("\(error.localizedDescription)")
                            }
                        }
                        
                    }
                }
            case .Failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }

}

