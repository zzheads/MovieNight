//
//  Page.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Page: JSONDecodable {
    let page: Int
    let total_pages: Int
    let total_results: Int
    let results: [JSON]
    
    init?(JSON: JSON) {
        guard
            let page = JSON["page"] as? Int,
            let total_pages = JSON["total_pages"] as? Int,
            let total_results = JSON["total_results"] as? Int,
            let results = JSON["results"] as? [JSON]
            else {
                return nil
        }
        self.page = page
        self.total_pages = total_pages
        self.total_results = total_results
        self.results = results
    }
}
