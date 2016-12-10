//
//  Credits.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Credits: JSONDecodable {
    let id: Int
    var cast: [Cast] = []
    var crew: [Crew] = []
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let cast = JSON["cast"] as? [JSON],
            let crew = JSON["crew"] as? [JSON]
            else {
                return nil
        }
        self.id = id
        for json in cast {
            if let castObject = Cast(JSON: json) {
                self.cast.append(castObject)
            }
        }
        for json in crew {
            if let crewObject = Crew(JSON: json) {
                self.crew.append(crewObject)
            }
        }
    }
}

extension Credits: CustomStringConvertible {
    var description: String {
        var description = "Cast: \n"
        for cast in self.cast {
            description += "\(cast)\n"
        }
        description += "Crew: \n"
        for crew in self.crew {
            description += "\(crew)\n"
        }
        return description
    }
}
