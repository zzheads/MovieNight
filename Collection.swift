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
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    var parts: [MovieHead]?
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let name = JSON["name"] as? String
            else {
                return nil
        }
        let overview = JSON["overview"] as? String
        let poster_path = JSON["poster_path"] as? String
        let backdrop_path = JSON["backdrop_path"] as? String
        
        self.id = id
        self.name = name
        self.overview = overview
        self.poster_path = poster_path
        self.backdrop_path = backdrop_path
        
        if let jsonArray = JSON["parts"] as? [JSON] {
            self.parts = []
            for json in jsonArray {
                if let part = MovieHead(JSON: json) {
                    self.parts?.append(part)
                }
            }
        }
    }

}
