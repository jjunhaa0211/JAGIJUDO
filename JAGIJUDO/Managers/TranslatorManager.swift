import Alamofire
import Foundation

/// 파파고 API 서비스 종료
struct TranslatorManager {
    var sourceLanguage: Language = .ko
    var targetLanguage: Language = .en
    
    func translate(from text: String, completionHandler: @escaping (String) -> Void) {
        guard let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt") else { return }
        let requestModel = TranslateRequesModel(
            source: sourceLanguage.languageCode,
            target: targetLanguage.languageCode,
            text: text
        )
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "IsPeMifoVQcsjB43NOwB",
            "X-Naver-Client-Secret": "oq0SkC8fHx"
        ]
        
        AF
            .request(url, method: .post, parameters: requestModel, headers: header)
            .responseDecodable(of: TranslateReponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result.translatedText)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
}
