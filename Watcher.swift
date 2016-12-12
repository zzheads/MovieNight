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
