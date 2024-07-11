import Foundation

struct Bookmark: Codable {
    let sourceLangue: Language
    let translatedLanguage: Language
    
    let sourceText: String
    let translatedText: String
}
