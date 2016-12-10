//
//  Crew.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Crew: JSONDecodable {
    let credit_id: String
    let department: String
    let id: Int
    let job: String
    let name: String
    let profile_path: String?
    
    init?(JSON: JSON) {
        guard
            let id = JSON["id"] as? Int,
            let name = JSON["name"] as? String,
            let department = JSON["department"] as? String,
            let job = JSON["job"] as? String,
            let credit_id = JSON["credit_id"] as? String
            else {
                return nil
        }
        let profile_path = JSON["profile_path"] as? String
        
        self.id = id
        self.name = name
        self.department = department
        self.job = job
        self.credit_id = credit_id
        self.profile_path = profile_path
    }
}

extension Crew: CustomStringConvertible {
    var description: String {
        return "\(self.name), \(self.job) of \(self.department) department"
    }
}
