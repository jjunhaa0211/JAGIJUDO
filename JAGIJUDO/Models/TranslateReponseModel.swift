//
//  TranslateReponseModel.swift
//  JAGIJUDO
//
//  Created by 박준하 on 7/10/24.
//

import Foundation

struct TranslateReponseModel: Decodable {
    private let message: Message
    
    var translatedText: String { message.result.translatedText }
    
    struct Message: Decodable {
        let result: Result
    }
    
    struct Result: Decodable {
//        let srcLangType: String
//        let tarLangType: String
        let translatedText: String
    }
}
