//
//  Preferences.swift
//  MovieNight
//
//  Created by Alexey Papin on 12.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Preferences {
    var weightGenre: Float
    var weightActor: Float
    var weightNew: Float
    var weightPopularity: Float
    
    var genreIds: [Int]
    var actorIds: [Int]
}
