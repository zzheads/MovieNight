//
//  ActorCredits.swift
//  MovieNight
//
//  Created by Alexey Papin on 16.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct MovieCredits: JSONDecodable {
    let id: Int
    var movieCast: [MovieCast] = []
    var movieCrew: [MovieCrew] = []
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let movieCastJSONArray = JSON["cast"] as? [JSON],
            let movieCrewJSONArray = JSON["crew"] as? [JSON]
            else {
                return nil
        }
        
        self.id = id
        for json in movieCastJSONArray {
            if let movieCast = MovieCast(JSON: json) {
                self.movieCast.append(movieCast)
            }
        }
        for json in movieCrewJSONArray {
            if let movieCrew = MovieCrew(JSON: json) {
                self.movieCrew.append(movieCrew)
            }
        }
    }
}
