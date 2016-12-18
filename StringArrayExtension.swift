//
//  StringArrayExtension.swift
//  MovieNight
//
//  Created by Alexey Papin on 10.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

// Make string divided by commas from array of strings

extension Sequence where Iterator.Element == String {
    var toString: String {
        var str = "";
        for element in self {
            str += "\(element), "
        }
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = String(str.characters.dropLast()) + ".\n"
        return str
    }
}

extension Sequence where Iterator.Element == Int {
    var toString: String {
        var str = "";
        for element in self {
            str += "\(element), "
        }
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = String(str.characters.dropLast()) 
        return str
    }
}

