//
//  Part.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct MovieHead: JSONDecodable {
    let id: Int
    let title: String
    let adult: Bool
    let backdrop_path: String
    var genre_ids: [Int] = []
    let original_language: String
    let original_title: String
    let overview: String
    let release_date: String
    let poster_path: String
    let popularity: Double
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    init?(JSON: JSON) {
        guard
            let title = JSON["title"] as? String,
            let id = JSON["id"] as? Int,
            let adult = JSON["adult"] as? Bool,
            let backdrop_path = JSON["backdrop_path"] as? String,
            let genre_ids = JSON["genre_ids"] as? [Int],
            let original_language = JSON["original_language"] as? String,
            let original_title = JSON["original_title"] as? String,
            let overview = JSON["overview"] as? String,
            let popularity = JSON["popularity"] as? Double,
            let poster_path = JSON["poster_path"] as? String,
            let release_date = JSON["release_date"] as? String,
            let video = JSON["video"] as? Bool,
            let vote_average = JSON["vote_average"] as? Double,
            let vote_count = JSON["vote_count"] as? Int
            else {
                return nil
        }
        
        self.id = id
        self.title = title
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.genre_ids = genre_ids
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.release_date = release_date
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
}

extension MovieHead: Idable {
    
}

extension MovieHead: Ratingable {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self.release_date)
    }
    
    var genreIds: [Int] {
        return self.genre_ids
    }
}
