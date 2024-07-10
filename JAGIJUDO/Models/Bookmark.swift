//
//  Bookmark.swift
//  JAGIJUDO
//
//  Created by 박준하 on 7/9/24.
//

import Foundation

struct Bookmark: Codable {
    let sourceLangue: Language
    let translatedLanguage: Language
    
    let sourceText: String
    let translatedText: String
}
