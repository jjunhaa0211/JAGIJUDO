//
//  Type.swift
//  JAGIJUDO
//
//  Created by 박준하 on 7/10/24.
//

import Foundation
import UIKit

enum `Type` {
    case source
    case target
    
    var color: UIColor {
        switch self {
        case .source: return .label
        case .target: return .mainTintColor
        }
    }
}
