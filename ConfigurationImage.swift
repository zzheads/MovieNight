//
//  ConfigurationImage.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct ConfigurationImage: JSONDecodable {
    let base_url: String
    let secure_base_url: String
    let backdrop_sizes: [String]
    let logo_sizes: [String]
    let poster_sizes: [String]
    let profile_sizes: [String]
    let still_sizes: [String]
    
    init?(JSON: JSON) {
        guard
            let base_url = JSON["base_url"] as? String,
            let secure_base_url = JSON["secure_base_url"] as? String,
            let backdrop_sizes = JSON["backdrop_sizes"] as? [String],
            let logo_sizes = JSON["logo_sizes"] as? [String],
            let poster_sizes = JSON["poster_sizes"] as? [String],
            let profile_sizes = JSON["profile_sizes"] as? [String],
            let still_sizes = JSON["still_sizes"] as? [String]
            else {
                return nil
        }
        
        self.base_url = base_url
        self.secure_base_url = secure_base_url
        self.backdrop_sizes = backdrop_sizes
        self.logo_sizes = logo_sizes
        self.poster_sizes = poster_sizes
        self.profile_sizes = profile_sizes
        self.still_sizes = still_sizes
    }
}

extension ConfigurationImage: CustomStringConvertible {
    var description: String {
        var description = "Base URL: \(self.base_url)\n"
        description += "Secure Base URL: \(self.secure_base_url)\n"
        description += "Backdrop sizes: \(self.backdrop_sizes.toString)"
        description += "Logo sizes: \(self.logo_sizes.toString)"
        description += "Poster sizes: \(self.poster_sizes.toString)"
        description += "Profile sizes: \(self.profile_sizes.toString)"
        description += "Still sizes: \(self.still_sizes.toString)"
        return description
    }
}
