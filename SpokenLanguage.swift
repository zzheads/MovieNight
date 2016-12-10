//
//  SpokenLanguage.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct SpokenLanguage: JSONDecodable {
    let iso_639_1: String
    let name: String
    
    internal init?(JSON: JSON) {
        guard
            let iso_639_1 = JSON["iso_639_1"] as? String,
            let name = JSON["name"] as? String
            else {
                return nil
        }
        self.iso_639_1 = iso_639_1
        self.name = name
    }
}
