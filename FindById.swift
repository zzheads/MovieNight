//
//  FindById.swift
//  MovieNight
//
//  Created by Alexey Papin on 14.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation

protocol Idable {
    var id: Int { get }
    var title: String { get }
}

extension Array where Element: Idable {
    func findById(id: Int) -> Idable? {
        for el in self {
            if el.id == id {
                return el
            }
        }
        return nil
    }
    
    var stringWithIds: String? {
        if self.isEmpty {
            return nil
        }
        var string = ""
        for elem in self {
            string += "\(elem.id), "
        }
        let result = String(string.trimmingCharacters(in: .whitespaces).characters.dropLast())
        return result
    }
}
