//
//  Rating.swift
//  MovieNight
//
//  Created by Alexey Papin on 13.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Rating {
    let watcher: Watcher
    let movies: [Movie]
    let actors: [Actor]
    let genres: [Genre]
    
    var rating: [Int: Float] = [:]
    
    init?(watcher: Watcher, movies: [Movie], actors: [Actor], genres: [Genre]) {
        self.watcher = watcher
        self.movies = movies
        self.actors = actors
        self.genres = genres
        
        guard
            let weights = watcher.weights,
            let preferences = watcher.preferences
            else {
                return nil
        }
        let weightGenre = weights.weightGenre
        let weightActor = weights.weightActor
        let weightNew = weights.weightNew
        let weightPopularity = weights.weightPopularity
        let genreIds = preferences.genreIds
        let actorIds = preferences.actorIds

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var maxNew = dateFormatter.date(from: "1800-01-01")!    // TODO: Set actual date
        var minNew = dateFormatter.date(from: "2016-12-01")!
        var maxPopularity = movies[0].popularity!
        var minPopularity = movies[0].popularity!
        
        
        // Calc min and max values for release date and popularity of all movies
        for movie in movies {
            guard let dateString = movie.release_date, let date = dateFormatter.date(from: dateString), let popularity = movie.popularity else {
                break
            }
            
            if date > maxNew {
                maxNew = date
            }
            if date < minNew {
                minNew = date
            }
            if popularity > maxPopularity {
                maxPopularity = popularity
            }
            if popularity < minPopularity {
                minPopularity = popularity
            }
        }

        let allTimeInterval = Float(maxNew.timeIntervalSince(minNew))
        let allPopInterval = Float(maxPopularity - minPopularity)
        
        for movie in movies {
            var rating: Float = 0
            for genre in genres {
                if (movie.genres?.contains(where: { $0.id == genre.id }))! {
                    rating += weightGenre
                }
            }
            for actor in actors {
                if actor.known_for.contains(where: { $0.id == movie.id }) {
                    rating += weightActor
                }
            }
            if let dateString = movie.release_date, let date = dateFormatter.date(from: dateString) {
                let timeIntervalFromMinNew = Float(date.timeIntervalSince(minNew))
                rating += (allTimeInterval - timeIntervalFromMinNew) * weightNew
            }
            if let popularity = movie.popularity {
                rating += (Float(maxPopularity) - Float(popularity)) * weightPopularity / allPopInterval
            }
            
            self.rating.updateValue(rating, forKey: movie.id)
        }
    }
}
