//
//  AppColors.swift
//  MovieNight
//
//  Created by Alexey Papin on 12.12.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation
import UIKit

enum AppColors {
    case Rose
    
    var color: UIColor {
        switch self {
        case .Rose: return UIColor(red: 240/255, green: 177/255, blue: 177/255, alpha: 1.0)
        }
    }
}
