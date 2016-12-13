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
    var preferences: Preferences?
    
    init(name: String, weights: Weights? = nil, preferences: Preferences? = nil) {
        self.name = name
        self.weights = weights
        self.preferences = preferences
    }
}

extension Sequence where Iterator.Element == Watcher {
    var allSet: Bool {
        for watcher in self {
            if watcher.preferences == nil {
                return false
            } else {
                if (watcher.preferences?.actorIds.isEmpty)! {
                    return false
                }
                if (watcher.preferences?.genreIds.isEmpty)! {
                    return false
                }
            }
            if watcher.weights == nil {
                return false
            }
        }
        return true
    }
}
