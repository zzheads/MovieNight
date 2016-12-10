//
//  Job.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Job: JSONDecodable {
    let department: String
    let job_list: [String]
    
    init?(JSON: JSON) {
        guard
            let department = JSON["department"] as? String,
            let job_list = JSON["job_list"] as? [String]
            else {
                return nil
        }
        self.department = department
        self.job_list = job_list
    }
}
