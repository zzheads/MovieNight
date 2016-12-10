//
//  Job.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

struct Jobs: JSONDecodable {
    var jobs: [Job] = []
    
    init?(JSON: JSON) {
        guard
            let jsonArray = JSON["jobs"] as? [JSON]
            else {
                return nil
        }
        for jsonElement in jsonArray {
            if let job = Job(JSON: jsonElement) {
                self.jobs.append(job)
            }
        }
    }
}

extension Jobs: CustomStringConvertible {
    var description: String {
        var description = "Jobs:\n\n"
        for job in self.jobs {
            description += "\(job.department.uppercased()): \(job.job_list.toString)\n"
        }
        return description
    }
}
