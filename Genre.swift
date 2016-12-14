//
//  Genre.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Genre: JSONDecodable {
    let id: Int
    let name: String
    
    internal init?(JSON: JSON) {
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

extension Genre: Idable {
    var title: String {
        return self.name
    }
}
