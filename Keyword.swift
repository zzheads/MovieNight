//
//  Keyword.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Keyword: JSONDecodable {
    let id: Int
    let name: String
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let name = JSON["name"] as? String
            else {
                return nil
        }
        self.id = id
        self.name = name
    }
}
