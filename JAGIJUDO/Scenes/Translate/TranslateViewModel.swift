//
//  TranslateViewModel.swift
//  JAGIJUDO
//
//  Created by 박준하 on 7/10/24.
//

import UIKit

protocol TranslationServiceType {
    func translate(text: String, from sourceLanguage: Language, to targetLanguage: Language, completion: @escaping (String?) -> Void)
}
class TranslateViewModel {
    struct Dependency {
        let translationService: TranslationServiceType
        let coordinator: Coordinator
    }

    private let translationService: TranslationServiceType
    private let coordinator: Coordinator

    init(dependency: Dependency) {
        self.translationService = dependency.translationService
        self.coordinator = dependency.coordinator
    }

    func translate(text: String, from sourceLanguage: Language, to targetLanguage: Language, completion: @escaping (String?) -> Void) {
        translationService.translate(text: text, from: sourceLanguage, to: targetLanguage) { translatedText in
            DispatchQueue.main.async {
                completion(translatedText)
            }
        }
    }

    func dismiss(_ viewController: UIViewController) {
        coordinator.dismiss(viewController: viewController, animated: true)
    }
}
