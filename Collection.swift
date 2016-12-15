//
//  Collection.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Collection: JSONDecodable {
    let id: Int
    let name: String
    let overview: String
    let poster_path: String
    let backdrop_path: String
    var parts: [MovieHead] = []
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let name = JSON["name"] as? String,
            let overview = JSON["overview"] as? String,
            let poster_path = JSON["poster_path"] as? String,
            let backdrop_path = JSON["backdrop_path"] as? String,
            let partsJSONArray = JSON["parts"] as? [JSON]
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.overview = overview
        self.poster_path = poster_path
        self.backdrop_path = backdrop_path
        
        for json in partsJSONArray {
            if let part = MovieHead(JSON: json) {
                self.parts.append(part)
            }
        }
    }

}
