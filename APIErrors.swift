//
//  APIErrors.swift
//  MovieNight
//
//  Created by Alexey Papin on 09.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

enum APIError: Error {
    case NoResponse(message: String)
}
