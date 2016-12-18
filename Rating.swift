//
//  Rating.swift
//  MovieNight
//
//  Created by Alexey Papin on 13.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

protocol KnownForType {
    var knownFor: [Idable] { get }
}

protocol Ratingable: Idable {
    var id: Int { get }
    var title: String { get }
    var genreIds: [Int] { get }
    var date: Date? { get }
    var popularity: Double { get }
}

extension Array where Element: Ratingable {
    var minDate: Date? {
        if (!self.isEmpty) {
            guard var minDate = self[0].date else {
                return nil
            }
            for el in self {
                guard let elDate = el.date else {
                    break
                }
                if elDate < minDate {
                    minDate = elDate
                }
            }
            return minDate
        }
        return nil
    }
    
    var maxDate: Date? {
        if (!self.isEmpty) {
            guard var maxDate = self[0].date else {
                return nil
            }
            for el in self {
                guard let elDate = el.date else {
                    break
                }
                if elDate > maxDate {
                    maxDate = elDate
                }
            }
            return maxDate
        }
        return nil
    }
    
    var minPopularity: Double? {
        if (!self.isEmpty) {
            var minPop = self[0].popularity
            for el in self {
                if el.popularity < minPop {
                    minPop = el.popularity
                }
            }
            return minPop
        }
        return nil
    }

    var maxPopularity: Double? {
        if (!self.isEmpty) {
            var maxPop = self[0].popularity
            for el in self {
                if el.popularity > maxPop {
                    maxPop = el.popularity
                }
            }
            return maxPop
        }
        return nil
    }
    
    func ratings(for watcher: Watcher) -> [Int: Double]? {
        guard
            let minDate = self.minDate,
            let maxDate = self.maxDate,
            let minPop = self.minPopularity,
            let maxPop = self.maxPopularity,
            let weights = watcher.weights
            else {
                return nil
        }
        let weightGenre = weights.weightGenre + 1
        let weightActor = weights.weightActor + 1
        let weightDate = weights.weightNew + 1
        let weightPop = weights.weightPopularity + 1
        
        var result: [Int: Double] = [:]
        
        for element in self {
            var rating: Double = 0
            
            if let movieIdsByGenres = watcher.movieIdsByGenres {
                for genreId in element.genreIds {
                    if (movieIdsByGenres.contains(genreId)) {
                        rating += Double(weightGenre)
                    }
                }
            }
            if let movieIdsByActors = watcher.movieIdsByActors {
                if movieIdsByActors.contains(element.id) {
                    rating += Double(weightActor)
                }
            }
            let allIntervalDate = maxDate.timeIntervalSince(minDate)
            if let valueDate = element.date {
                let valueDateInterval = valueDate.timeIntervalSince(minDate)
                rating += Double(weightDate) * (valueDateInterval / allIntervalDate)
            }
            
            let allIntervalPop = maxPop - minPop
            let valuePop = element.popularity - minPop
            rating += Double(weightPop) * (valuePop / allIntervalPop)
            
            result.updateValue(rating, forKey: element.id)
        }
        return result
    }

    func rating(for watcher: Watcher, index: Int) -> Double? {
        guard
            let minDate = self.minDate,
            let maxDate = self.maxDate,
            let minPop = self.minPopularity,
            let maxPop = self.maxPopularity,
            let weights = watcher.weights
            else {
                return nil
        }
        let weightGenre = weights.weightGenre
        let weightActor = weights.weightActor
        let weightDate = weights.weightNew
        let weightPop = weights.weightPopularity + 1
        
        let element = self[index]
        var rating: Double = 0
        
        if let movieIdsByGenres = watcher.movieIdsByGenres {
            for genreId in element.genreIds {
                if (movieIdsByGenres.contains(genreId)) {
                    rating += Double(weightGenre)
                }
            }
        }
        if let movieIdsByActors = watcher.movieIdsByActors {
            if movieIdsByActors.contains(element.id) {
                rating += Double(weightActor)
            }
        }
        let allIntervalDate = maxDate.timeIntervalSince(minDate)
        if let valueDate = element.date {
            let valueDateInterval = valueDate.timeIntervalSince(minDate)
            rating += Double(weightDate) * (valueDateInterval / allIntervalDate)
        }
        
        let allIntervalPop = maxPop - minPop
        let valuePop = element.popularity - minPop
        rating += Double(weightPop) * (valuePop / allIntervalPop)
        
        return rating
    }
    
    func sortByRating(for watcher: Watcher) -> [Ratingable]? {
        guard let ratingsDict = self.ratings(for: watcher) else {
            return nil
        }
        
        for (key, value) in ratingsDict {
            if (value >= 100) {
                print("key(id)=\(key), value=\(value), movie=\((self.findById(id: key))?.title)")
            }
        }
        
        let sortedIds = ratingsDict.keysSortedByValue(isOrderedBefore: { $0 > $1 })
        var result: [Ratingable] = []
        for id in sortedIds {
            if let sortedElement = self.findById(id: id) {
                result.append(sortedElement as! Ratingable)
            }
        }
        return result
    }
}
