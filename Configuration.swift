//
//  Configuration.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Configuration: JSONDecodable {
    let change_keys: [String]
    var images: ConfigurationImage
    
    init?(JSON: JSON) {
        guard
            let change_keys = JSON["change_keys"] as? [String],
            let jsonImages = JSON["images"] as? JSON,
            let images = ConfigurationImage(JSON: jsonImages)
            else {
                return nil
        }
        self.change_keys = change_keys
        self.images = images
    }
}

extension Configuration: CustomStringConvertible {
    var description: String {
        return "Configuration: \n"
            + "Images: \(self.images)"
            + "Change keys: \(self.change_keys.toString)"
    }
}
