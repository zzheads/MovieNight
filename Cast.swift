//
//  Cast.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Cast: JSONDecodable {
    let cast_id: Int
    let character: String
    let credit_id: String
    let id: Int
    let name: String
    let order: Int
    let profile_path: String?

    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let name = JSON["name"] as? String,
            let cast_id = JSON["cast_id"] as? Int,
            let character = JSON["character"] as? String,
            let credit_id = JSON["credit_id"] as? String,
            let order = JSON["order"] as? Int
            else {
                return nil
        }
        let profile_path = JSON["profile_path"] as? String
        
        self.id = id
        self.name = name
        self.cast_id = cast_id
        self.character = character
        self.credit_id = credit_id
        self.order = order
        self.profile_path = profile_path
    }
}

extension Cast: CustomStringConvertible {
    var description: String {
        return "\(self.name), character: \(self.character)"
    }
}
