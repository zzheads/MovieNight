//
//  ProductionCountry.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct ProductionCountry: JSONDecodable {
    let iso_3166_1: String
    let name: String
    
    internal init?(JSON: JSON) {
        guard
            let iso_3166_1 = JSON["iso_3166_1"] as? String,
            let name = JSON["name"] as? String
            else {
                return nil
        }
        self.iso_3166_1 = iso_3166_1
        self.name = name
    }
}
