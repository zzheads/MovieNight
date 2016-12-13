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
    var ratings: [Rating] = []
    
    
    let apiClient = ResourceAPIClient()
    
    init(watchers: [Watcher]) {
        self.watchers = watchers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        apiClient.fetchPages(resourceType: ResourceType.Movie(.TopRated(pages: 20)), resourceClass: MovieHead.self) { movieHeads in
            for watcher in self.watchers {
                if let rating = Rating(watcher: watcher, movieHeads: movieHeads) {
                    self.ratings.append(rating)
                }
            }
            
            for i in 0..<movieHeads.count {
                let movieHead = movieHeads[i]
                guard
                    let rating1 = self.ratings[0].rating[movieHead.id],
                    let rating2 = self.ratings[1].rating[movieHead.id]
                    else {
                        break
                }
                print("\(i). \(movieHead.title) \(rating1) \(rating2)")
            }
            
        }
    }
    
}
