//
//  Movie.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Movie: JSONDecodable {
    let id: Int
    let title: String
    let adult: Bool?
    let backdrop_path: String?
    let belongs_to_collection: [Collection]?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let imdb_id: String?         //    minLength: 9 maxLength: 9     pattern: ^tt[0-9]{7}
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let production_companies: [ProductionCompany]?
    let production_countries: [ProductionCountry]?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let spoken_languages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
    
    internal init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let title = JSON["title"] as? String
            else {
                return nil
        }
        let adult = JSON["adult"] as? Bool
        let backdrop_path = JSON["backdrop_path"] as? String
        let belongs_to_collection = JSON["belongs_to_collection"] as? [Collection]
        let budget = JSON["budget"] as? Int
        let genres = JSON["genres"] as? [Genre]
        let homepage = JSON["homepage"] as? String
        let imdb_id = JSON["imdb_id"] as? String         //    minLength: 9 maxLength: 9     pattern: ^tt[0-9]{7}
        let original_language = JSON["original_language"] as? String
        let original_title = JSON["original_title"] as? String
        let overview = JSON["overview"] as? String
        let popularity = JSON["popularity"] as? Double
        let poster_path = JSON["poster_path"] as? String
        let production_companies = JSON["production_companies"] as? [ProductionCompany]
        let production_countries = JSON["production_countries"] as? [ProductionCountry]
        let release_date = JSON["release_date"] as? String
        let revenue = JSON["revenue"] as? Int
        let runtime = JSON["runtime"] as? Int
        let spoken_languages = JSON["spoken_languages"] as? [SpokenLanguage]
        let status = JSON["status"] as? String
        let tagline = JSON["tagline"] as? String
        let video = JSON["video"] as? Bool
        let vote_average = JSON["vote_average"] as? Double
        let vote_count = JSON["vote_count"] as? Int
        
        self.id = id
        self.title = title
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.belongs_to_collection = belongs_to_collection
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.imdb_id = imdb_id         //    minLength: 9 maxLength: 9     pattern: ^tt[0-9]{7}
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.production_companies = production_companies
        self.production_countries = production_countries
        self.release_date = release_date
        self.revenue = revenue
        self.runtime = runtime
        self.spoken_languages = spoken_languages
        self.status = status
        self.tagline = tagline
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
}

extension Movie: CustomStringConvertible {
    var description: String {
        var description = "Movie: \(self.title) (id: \(self.id)): \n"
        if let adult = self.adult {
            description += "Adult: \(adult)\n"
        }
        if let genres = self.genres {
            description += "Genres: "
            for genre in genres {
                description += "\(genre.name), "
            }
            description += "\n"
        }
        if let release_date = self.release_date {
            description += "Release date: \(release_date)\n"
        }
        if let overview = self.overview {
            description += "Overview: \(overview)\n"
        }
        if let homepage = self.homepage {
            description += "Homepage: \(homepage)\n"
        }
        if let popularity = self.popularity {
            description += "Popularity: \(popularity)\n"
        }
        if let imdb_id = self.imdb_id {
            description += "IMDB: \(imdb_id)\n"
        }

        return description
    }
}
