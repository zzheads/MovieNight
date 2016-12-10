//
//  PersonImage.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct PersonImage: JSONDecodable {
    let id: Int
    var profiles: [Pic]?
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int
            else {
                return nil
        }
        self.id = id
        if let jsonArray = JSON["profiles"] as? [JSON] {
            self.profiles = []
            for json in jsonArray {
                if let profile = Pic(JSON: json) {
                    self.profiles?.append(profile)
                }
            }
        }
    }
}
