//
//  Keywords.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Keywords: JSONDecodable {
    let id: Int
    var keywords: [Keyword] = []
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let jsonArray = JSON["keywords"] as? [JSON]
            else {
                return nil
        }
        self.id = id
        for json in jsonArray {
            if let keyword = Keyword(JSON: json) {
                self.keywords.append(keyword)
            }
        }
    }
}

extension Keywords: CustomStringConvertible {
    var description: String {
        var description = "Keywords: "
        for keyword in self.keywords {
            description += "\(keyword.name), "
        }
        return description
    }
}
