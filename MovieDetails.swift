//
//  MovieDetails.swift
//  MovieNight
//
//  Created by Alexey Papin on 15.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

class MovieDetails {
    let movie: Movie
    let image: Image
    let actors: [Actor]
    
    init(movie: Movie, image: Image, actors: [Actor]) {
        self.movie = movie
        self.image = image
        self.actors = actors
    }
}
