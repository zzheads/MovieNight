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
        apiClient.fetchPages(resourceType: ResourceType.Movie(.Popular(pages: 2)), resourceClass: Movie.self) { movies in
            apiClient.fetchResource(resource: ResourceType.Configuration, resourceClass: Configuration.self) { result in
                switch result {
                case .Success(let configuration):
                    for movie in movies {
                        apiClient.fetchResource(resource: ResourceType.Movie(.Images(id: movie.id)), resourceClass: Image.self) { result in
                            switch result {
                            case .Success(let image):
                                print("Images of: \(movie.title.uppercased()):")
                                if let posters = image.posters {
                                    for poster in posters {
                                        print("\(configuration.images.base_url+configuration.images.poster_sizes[1]+poster.file_path)")
                                    }
                                }
                            case .Failure(let error as NSError):
                                switch error.code {
                                case HTTPStatusCodeError.TooManyRequests.rawValue:
                                    print("ViewController handler: Too many requests, will sleep 1 second...")
                                    
                                default:
                                    print("fetchPages can't handle error: \(error.localizedDescription)")
                                }
                            default: break
                            }
                        }
                    }
                case .Failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        }
    }

}

