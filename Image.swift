//
//  Images.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Image: JSONDecodable {
    let id: Int
    var backdrops: [Pic]?
    var posters: [Pic]?
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int
            else {
                return nil
        }
        self.id = id
        if let jsonArray = JSON["backdrops"] as? [JSON] {
            self.backdrops = []
            for json in jsonArray {
                if let backdrop = Pic(JSON: json) {
                    self.backdrops?.append(backdrop)
                }
            }
        }
        if let jsonArray = JSON["posters"] as? [JSON] {
            self.posters = []
            for json in jsonArray {
                if let poster = Pic(JSON: json) {
                    self.posters?.append(poster)
                }
            }
        }
    }
}
