//
//  Actor.swift
//  MovieNight
//
//  Created by Alexey Papin on 13.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Actor: JSONDecodable {
    let id: Int
    let name: String
    let popularity: Double
    let adult: Bool
    var known_for: [MovieHead] = []
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let name = JSON["name"] as? String,
            let popularity = JSON["popularity"] as? Double,
            let adult = JSON["adult"] as? Bool,
            let jsonArrayKnown_for = JSON["known_for"] as? [JSON]
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.popularity = popularity
        self.adult = adult
        for jsonElement in jsonArrayKnown_for {
            if let known_for = MovieHead(JSON: jsonElement) {
                self.known_for.append(known_for)
            }
        }
    }
}
