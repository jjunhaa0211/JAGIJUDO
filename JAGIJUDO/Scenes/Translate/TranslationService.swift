import Foundation

class TranslationService: TranslationServiceType {
    func translate(text: String, from sourceLanguage: Language, to targetLanguage: Language, completion: @escaping (String?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let translatedText = "[Translated]\(text)"
            completion(translatedText)
        }
    }
}
