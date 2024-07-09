//
//  Language.swift
//  JAGIJUDO
//
//  Created by 박준하 on 7/9/24.
//

import Foundation

public enum Language: CaseIterable {
    case ko
    case en
    case ja
    case ch
    
    var title: String {
        switch self {
        case .ko: return "한국어"
        case .en: return "영어"
        case .ja: return "일본어"
        case .ch: return "중국어"
        }
    }
}
