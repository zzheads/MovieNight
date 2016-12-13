//
//  Watcher.swift
//  MovieNight
//
//  Created by Alexey Papin on 12.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Watcher {
    let name: String
    var weights: Weights?
    var genres: [Genre]?
    var actors: [Actor]?

    
    init(name: String, weights: Weights? = nil, genres: [Genre]? = nil, actors: [Actor]? = nil) {
        self.name = name
        self.weights = weights
        self.genres = genres
        self.actors = actors
    }
}

extension Sequence where Iterator.Element == Watcher {
    var allSet: Bool {
        for watcher in self {
            guard
                let _ = watcher.weights,
                let _ = watcher.genres,
                let _ = watcher.actors
                else {
                    return false
            }
        }
        return true
    }
}
