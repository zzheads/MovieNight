//
//  Movie.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Movie: JSONDecodable, Idable {
    let id: Int
    let title: String
    let adult: Bool
    let backdrop_path: String
    var belongs_to_collection: [Collection]?
    let budget: Int
    var genres: [Genre] = []
    let homepage: String
    let imdb_id: String         //    minLength: 9 maxLength: 9     pattern: ^tt[0-9]{7}
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    var production_companies: [ProductionCompany] = []
    var production_countries: [ProductionCountry] = []
    let release_date: String
    let revenue: Int
    let runtime: Int
    var spoken_languages: [SpokenLanguage] = []
    let status: String
    let tagline: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    internal init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let title = JSON["title"] as? String,
            let adult = JSON["adult"] as? Bool,
            let backdrop_path = JSON["backdrop_path"] as? String,
            let budget = JSON["budget"] as? Int,
            let genresJSONArray = JSON["genres"] as? [JSON],
            let homepage = JSON["homepage"] as? String,
            let imdb_id = JSON["imdb_id"] as? String,         //    minLength: 9 maxLength: 9     pattern: ^tt[0-9]{7}
            let original_language = JSON["original_language"] as? String,
            let original_title = JSON["original_title"] as? String,
            let overview = JSON["overview"] as? String,
            let popularity = JSON["popularity"] as? Double,
            let poster_path = JSON["poster_path"] as? String,
            let production_companiesJSONArray = JSON["production_companies"] as? [JSON],
            let production_countriesJSONArray = JSON["production_countries"] as? [JSON],
            let release_date = JSON["release_date"] as? String,
            let revenue = JSON["revenue"] as? Int,
            let runtime = JSON["runtime"] as? Int,
            let spoken_languagesJSONArray = JSON["spoken_languages"] as? [JSON],
            let status = JSON["status"] as? String,
            let tagline = JSON["tagline"] as? String,
            let video = JSON["video"] as? Bool,
            let vote_average = JSON["vote_average"] as? Double,
            let vote_count = JSON["vote_count"] as? Int
            else {
                return nil
        }
        if let belongs_to_collectionJSONArray = JSON["belongs_to_collection"] as? [JSON] {
            self.belongs_to_collection = []
            for json in belongs_to_collectionJSONArray {
                if let belongs_to_collection = Collection(JSON: json) {
                    self.belongs_to_collection?.append(belongs_to_collection)
                }
            }
        }
        
        self.id = id
        self.title = title
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.budget = budget
        self.homepage = homepage
        self.imdb_id = imdb_id                                          //    minLength: 9 maxLength: 9     pattern: ^tt[0-9]{7}
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.release_date = release_date
        self.revenue = revenue
        self.runtime = runtime
        self.status = status
        self.tagline = tagline
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
        
        for json in genresJSONArray {
            if let genre = Genre(JSON: json) {
                self.genres.append(genre)
            }
        }
        for json in production_companiesJSONArray {
            if let production_company = ProductionCompany(JSON: json) {
                self.production_companies.append(production_company)
            }
        }
        for json in production_countriesJSONArray {
            if let production_country = ProductionCountry(JSON: json) {
                self.production_countries.append(production_country)
            }
        }
        for json in spoken_languagesJSONArray {
            if let spoken_language = SpokenLanguage(JSON: json) {
                self.spoken_languages.append(spoken_language)
            }
        }
    }
}

extension Movie: CustomStringConvertible {
    var description: String {
        var description = "Movie: \(self.title) (id: \(self.id)): \n"
        description += "Adult: \(adult)\n"
        description += "Genres: "
        for genre in genres {
            description += "\(genre.name), "
        }
        description += "\n"
        
        description += "Release date: \(release_date)\n"
        description += "Overview: \(overview)\n"
        description += "Homepage: \(homepage)\n"
        description += "Popularity: \(popularity)\n"
        description += "IMDB: \(imdb_id)\n"

        return description
    }
}
