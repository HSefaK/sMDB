import Foundation

struct DetailMovie: Codable {
    let id: Int
    let title: String
    let backdropUrl: String?
    let posterUrl: String?
    let overview: String?
    let releaseDate: String
    let rating: Double
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case backdropUrl = "backdrop_path"
        case posterUrl = "poster_path"
        case overview
        case releaseDate = "release_date"
        case rating = "vote_average"
        case genres
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
