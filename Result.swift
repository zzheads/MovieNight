//
//  MovieContent.swift
//  MovieNight
//
//  Created by Alexey Papin on 14.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation
import UIKit

class Result {
    let id: Int
    let title: String
    let ratings: [Int]
    let image: UIImageView
    
    init(intersection: (element: MovieHead, inFirst: Int, inSecond: Int), config: Configuration, image: Image) {
        let movie = intersection.element
        self.id = movie.id
        self.title = movie.title
        self.ratings = [intersection.inFirst, intersection.inSecond]
        self.image = UIImageView()
        guard
            let posters = image.posters,
            let url = URL(string: config.images.secure_base_url + config.images.poster_sizes[0] + posters[0].file_path)
            else {
                return
        }
        self.image.downloadedFrom(url: url)
    }
}
