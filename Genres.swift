//
//  Genres.swift
//  MovieNight
//
//  Created by Alexey Papin on 13.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

class Genres: JSONDecodable {
    var genres: [Genre] = []
    
    required init?(JSON: JSON) {
        guard let genres = JSON["genres"] as? [JSON] else {
            return nil
        }
        for jsonGenre in genres {
            if let genre = Genre(JSON: jsonGenre) {
                self.genres.append(genre)
            }
        }
    }
}

extension Genres: CustomStringConvertible {
    var description: String {
        var description = "Genres: "
        for genre in genres {
            description += "\(genre.name), "
        }
        return description
    }
}
