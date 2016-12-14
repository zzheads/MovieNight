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
}
