import Foundation

class DetailMovieController {
    var movieId: Int?
    var movie: DetailMovie?
    var reviews = [Review]()
    
    private let networkService = NetworkService()
    
    func fetchMovie(completion: @escaping () -> Void) {
        guard let id = movieId else { return }
        let urlString = "\(Utils.baseUrl)\(id)?api_key=\(Utils.apiKey)&language=\(Utils.language)"
        let url = URL(string: urlString)
        guard let request = networkService.createRequest(url: url!, method: .get) else { return }
        networkService.dataLoader.loadData(using: request) { (data, _, _) in
            guard let data = data else { return }
            let result = self.networkService.decode(to: DetailMovie.self, data: data)
            guard let movieResult = result else { return }
            self.movie = movieResult
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchReviews(completion: @escaping () -> Void) {
        guard let id = movieId else { return }
        let urlString = "\(Utils.baseUrl)\(id)/reviews?api_key=\(Utils.apiKey)&language=\(Utils.language)"
        let url = URL(string: urlString)
        guard let request = networkService.createRequest(url: url!, method: .get) else { return }
        networkService.dataLoader.loadData(using: request) { (data, _, _) in
            guard let data = data else { return }
            let result = self.networkService.decode(to: ReviewResult.self, data: data)
            guard let reviewResult = result?.reviews else { return }
            self.reviews.append(contentsOf: reviewResult)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
