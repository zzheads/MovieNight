//
//  Weights.swift
//  MovieNight
//
//  Created by Alexey Papin on 12.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Weights: WeightType {
    var weightGenre: Int
    var weightActor: Int
    var weightNew: Int
    var weightPopularity: Int
}

protocol WeightType {
    var weightGenre: Int { get }
    var weightActor: Int { get }
    var weightNew: Int { get }
    var weightPopularity: Int { get }
}
