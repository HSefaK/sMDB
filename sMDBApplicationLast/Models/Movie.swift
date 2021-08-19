import Foundation

struct MovieResult: Codable {
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let poster: String?
    let releaseDate: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case poster = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
    }
}
