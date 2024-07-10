import Foundation

struct ChatGPTResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

struct Choice: Codable {
    let text: String
    let index: Int
    let logprobs: Int?
    let finish_reason: String
}
