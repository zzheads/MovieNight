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
    case Bordo
    case LightBlue
    case Blue
    
    var color: UIColor {
        switch self {
        case .Bordo: return UIColor(red: 180/255, green: 92/255, blue: 92/255, alpha: 1.0)
        case .Rose: return UIColor(red: 240/255, green: 177/255, blue: 177/255, alpha: 1.0)
        case .LightBlue: return UIColor(red: 193/255, green: 232/255, blue: 247/255, alpha: 1.0)
        case .Blue: return UIColor(red: 170/255, green: 220/255, blue: 240/255, alpha: 1.0)
        }
    }
}
