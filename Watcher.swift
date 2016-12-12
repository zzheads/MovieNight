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
    var preferences: Preferences?
    
    init(name: String, preferences: Preferences? = nil) {
        self.name = name
        self.preferences = preferences
    }
}
