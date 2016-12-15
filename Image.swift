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
    var backdrops: [Pic] = []
    var posters: [Pic] = []
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let backdropsJSONArray = JSON["backdrops"] as? [JSON],
            let postersJSONArray = JSON["posters"] as? [JSON]
            else {
                return nil
        }
        self.id = id
        for json in backdropsJSONArray {
            if let backdrop = Pic(JSON: json) {
                self.backdrops.append(backdrop)
            }
        }
        for json in postersJSONArray {
            if let poster = Pic(JSON: json) {
                self.posters.append(poster)
            }
        }
    }
}
