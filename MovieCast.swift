//
//  ActorCast.swift
//  MovieNight
//
//  Created by Alexey Papin on 16.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct MovieCast: JSONDecodable {
    let id: Int
    let title: String
    let adult: Bool
    let character: String
    let credit_id: String
    let original_title: String
    let poster_path: String?
    let release_date: String?
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let title = JSON["title"] as? String,
            let adult = JSON["adult"] as? Bool,
            let character = JSON["character"] as? String,
            let credit_id = JSON["credit_id"] as? String,
            let original_title = JSON["original_title"] as? String
            else {
                return nil
        }
        let poster_path = JSON["poster_path"] as? String
        let release_date = JSON["release_date"] as? String
        
        self.id = id
        self.title = title
        self.adult = adult
        self.character = character
        self.credit_id = credit_id
        self.original_title = original_title
        self.poster_path = poster_path
        self.release_date = release_date
    }
}
