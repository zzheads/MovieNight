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

protocol WeightType {
    var weightGenre: Float { get }
    var weightActor: Float { get }
    var weightNew: Float { get }
    var weightPopularity: Float { get }
}

extension Array where Element: Ratingable {
    var minDate: Date? {
        if (!self.isEmpty) {
            guard var minDate = self[0].date else {
                return nil
            }
            for el in self {
                guard let elDate = el.date else {
                    return nil
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
                    return nil
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
    
    func rating(index: Int, weights: WeightType?, genres: [Idable]?, actors: [KnownForType]?) -> Double? {
        if index > self.count || index < 0 {
            return nil
        }
        let element = self[index]
        guard
            let minDate = self.minDate,
            let maxDate = self.maxDate,
            let minPop = self.minPopularity,
            let maxPop = self.maxPopularity,
            let weights = weights,
            let genres = genres,
            let actors = actors
            else {
                return nil
        }
        let weightGenre = weights.weightGenre
        let weightActor = weights.weightActor
        let weightDate = weights.weightNew
        let weightPop = weights.weightPopularity
        
        var rating: Double = 0
        for genre in genres {
            if element.genreIds.contains(where: { $0 == genre.id }) {
                rating += Double(weightGenre)
            }
        }
        for actor in actors {
            if actor.knownFor.contains(where: { $0.id == element.id }) {
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
    
    func ratingBy(param: Double, min: Double, max: Double, weight: Double) -> Double {
        return param * weight / (max - min)
    }
    
    func ratings(weights: WeightType?, genres: [Idable]?, actors: [KnownForType]?) -> [Int: Double]? {
        guard
            let minDate = self.minDate,
            let maxDate = self.maxDate,
            let minPop = self.minPopularity,
            let maxPop = self.maxPopularity,
            let weights = weights,
            let genres = genres,
            let actors = actors
            else {
                return nil
        }
        let weightGenre = weights.weightGenre
        let weightActor = weights.weightActor
        let weightDate = weights.weightNew
        let weightPop = weights.weightPopularity
        
        var result: [Int: Double] = [:]
        
        for element in self {
            var rating: Double = 0
            
            for genre in genres {
                if element.genreIds.contains(where: { $0 == genre.id }) {
                    rating += Double(weightGenre)
                }
            }
            for actor in actors {
                if actor.knownFor.contains(where: { $0.id == element.id }) {
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
    
    func sortByRating(weights: WeightType?, genres: [Idable]?, actors: [KnownForType]?) -> [Ratingable]? {
        guard let ratingsDict = self.ratings(weights: weights, genres: genres, actors: actors) else {
            return nil
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

