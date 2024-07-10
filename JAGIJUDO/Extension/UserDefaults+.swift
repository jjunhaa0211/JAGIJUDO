//
//  UserDefaults+.swift
//  JAGIJUDO
//
//  Created by 박준하 on 7/10/24.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case bookmarks
    }
    
    var bookmarks: [Bookmark] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Key.bookmarks.rawValue) else { return [] }
            return (try? PropertyListDecoder().decode([Bookmark].self, from: data)) ?? []
        }
        set {
            let encoder = PropertyListEncoder()
            if let encodedData = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: Key.bookmarks.rawValue)
            }
        }
    }
}
