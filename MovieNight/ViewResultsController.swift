//
//  ViewResultsController.swift
//  MovieNight
//
//  Created by Alexey Papin on 13.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation
import UIKit

class ViewResultsController: UIViewController {
    
    let watchers: [Watcher]
    let ratings: [Rating] = []
    
    
    let apiClient = ResourceAPIClient()
    
    init(watchers: [Watcher]) {
        self.watchers = watchers
        for watcher in watchers {
            if let rating = Rating(watcher: watcher, movies: movies, actors: <#T##[Actor]#>, genres: <#T##[Genre]#>) {
                self.ratings.append(rating)
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        apiClient.fetchPages(resourceType: ResourceType.Movie(.TopRated(pages: 20)), resourceClass: Movie.self) { movies in
            print(movies)
        }
    }
    
}
