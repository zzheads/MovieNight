//
//  Backdrop.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Pic: JSONDecodable {
    let aspect_ratio: Double
    let file_path: String
    let height: Int
    let width: Int
    let iso_639_1: String?
    let vote_average: Double
    let vote_count: Int
    
    init?(JSON: JSON) {
        guard
            let aspect_ratio = JSON["aspect_ratio"] as? Double,
            let file_path = JSON["file_path"] as? String,
            let height = JSON["height"] as? Int,
            let width = JSON["width"] as? Int,
            let vote_average = JSON["vote_average"] as? Double,
            let vote_count = JSON["vote_count"] as? Int
            else {
                return nil
        }
        let iso_639_1 = JSON["iso_639_1"] as? String
        
        self.aspect_ratio = aspect_ratio
        self.file_path = file_path
        self.height = height
        self.width = width
        self.iso_639_1 = iso_639_1
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
}
