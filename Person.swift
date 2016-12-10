//
//  People.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

enum Gender: Int {
    case Female = 1
    case Male = 2
    case Unknown
    
    init(rawValue: Int) {
        switch rawValue {
        case 1: self = .Female
        case 2: self = .Male
        default: self = .Unknown
        }
    }
}

struct Person: JSONDecodable {
    let id: Int
    let name: String
    let adult: Bool
    var also_known_as: [String]?
    let biography: String
    let birthday: String
    let deathday: String
    let gender: Gender
    let homepage: String
    let imdb_id: String
    let place_of_birth: String
    let popularity: Double
    let profile_path: String?

    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let name = JSON["name"] as? String,
            let adult = JSON["adult"] as? Bool,
            let also_known_as = JSON["also_known_as"] as? [String]?,
            let biography = JSON["biography"] as? String,
            let birthday = JSON["birthday"] as? String,
            let deathday = JSON["deathday"] as? String,
            let gender = JSON["gender"] as? Int,
            let homepage = JSON["homepage"] as? String,
            let imdb_id = JSON["imdb_id"] as? String,
            let place_of_birth = JSON["place_of_birth"] as? String,
            let popularity = JSON["popularity"] as? Double
            else {
                return nil
        }
        
        let profile_path = JSON["profile_path"] as? String
        
        self.id = id
        self.name = name
        self.adult = adult
        self.also_known_as = also_known_as
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.gender = Gender(rawValue: gender)
        self.homepage = homepage
        self.imdb_id = imdb_id
        self.place_of_birth = place_of_birth
        self.popularity = popularity
        self.profile_path = profile_path
    }
}
