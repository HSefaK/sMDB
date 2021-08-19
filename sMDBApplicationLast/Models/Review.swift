import Foundation

struct ReviewResult: Codable {
    let reviews: [Review]
    enum CodingKeys: String, CodingKey {
        case reviews = "results"
    }
}

struct Review: Codable {
    let id: String
    let content: String
}
