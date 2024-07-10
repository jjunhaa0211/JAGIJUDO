//
//  TranslateRequesModel.swift
//  JAGIJUDO
//
//  Created by 박준하 on 7/10/24.
//

import Foundation

struct TranslateRequesModel: Codable {
    let source: String
    let target: String
    let text: String
}
