//
//  Timezone.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Timezone: JSONDecodable {
    let key: String
    var values: [String] = []
    
    init?(JSON: JSON) {
        guard
            let key = JSON.keys.first
            else {
                return nil
        }
        self.key = key
        self.values = JSON[key] as! [String]
    }
}

extension Sequence where Iterator.Element == Timezone {
    var forPrint: String {
        var description = "Timezones(\(self.underestimatedCount)):\n"
        var count = 1
        for element in self {
            description += "\(count). [\(element.key)]: \(element.values.toString)"
            count += 1
        }
        return description
    }
}
