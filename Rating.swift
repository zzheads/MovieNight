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
    let movieHeads: [MovieHead]
    let actors: [Actor]
    let genres: [Genre]
    
    var rating: [Int: Float] = [:]
    
    init?(watcher: Watcher, movieHeads: [MovieHead]) {
        guard
            let weights = watcher.weights,
            let genres = watcher.genres,
            let actors = watcher.actors
            else {
                return nil
        }
        
        self.watcher = watcher
        self.movieHeads = movieHeads
        self.genres = genres
        self.actors = actors
        
        let weightGenre = weights.weightGenre
        let weightActor = weights.weightActor
        let weightNew = weights.weightNew
        let weightPopularity = weights.weightPopularity

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var maxNew = dateFormatter.date(from: "1800-01-01")!    // TODO: Set actual date
        var minNew = dateFormatter.date(from: "2016-12-01")!
        var maxPopularity = movieHeads[0].popularity!
        var minPopularity = movieHeads[0].popularity!
        
        
        // Calc min and max values for release date and popularity of all movies
        for movieHead in movieHeads {
            guard let dateString = movieHead.release_date, let date = dateFormatter.date(from: dateString), let popularity = movieHead.popularity else {
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
        
        for movieHead in movieHeads {
            var rating: Float = 0
            for genre in genres {
                if let movieGenres = movieHead.genre_ids {
                    if (movieGenres.contains(where: { $0 == genre.id })) {
                        rating += weightGenre
                    }
                }
            }
            for actor in actors {
                if actor.known_for.contains(where: { $0.id == movieHead.id }) {
                    rating += weightActor
                }
            }
            if let dateString = movieHead.release_date, let date = dateFormatter.date(from: dateString) {
                let timeIntervalFromMinNew = Float(date.timeIntervalSince(minNew))
                rating += (allTimeInterval - timeIntervalFromMinNew) * weightNew
            }
            if let popularity = movieHead.popularity {
                rating += (Float(maxPopularity) - Float(popularity)) * weightPopularity / allPopInterval
            }
            
            self.rating.updateValue(rating, forKey: movieHead.id)
        }
    }
}
