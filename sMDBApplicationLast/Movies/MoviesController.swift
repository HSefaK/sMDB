import Foundation

class MoviesController {
    
    private enum MovieCategory {
        case NowPlaying
        case Upcoming
        case Popular
    }
    
    private func getUrl(from category: MovieCategory) -> URL {
        let queryStrings = "?api_key=\(Utils.apiKey)&language=\(Utils.language)"
        
        switch category {
        case .NowPlaying: return URL(string: Utils.baseUrl + "now_playing" + queryStrings)!
        case .Upcoming: return URL(string: Utils.baseUrl + "upcoming" + queryStrings)!
        case .Popular: return URL(string: Utils.baseUrl + "top_rated" + queryStrings)!
        }
    }
    
    private let networkService = NetworkService()
    
    private var movieCategory: MovieCategory?
    
    var movies = [[Movie]]()
    
    func fetchNowPlayingMovies(completion: @escaping () -> Void) {
        movieCategory = MovieCategory.NowPlaying
        let url = getUrl(from: movieCategory!)
        guard let request = networkService.createRequest(url: url, method: .get) else { return }
        networkService.dataLoader.loadData(using: request) { (data, _, _) in
            guard let data = data else { return }
            let result = self.networkService.decode(to: MovieResult.self, data: data)
            guard let movieResult = result?.movies else { return }
            self.movies.append(contentsOf: [movieResult])
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    func fetchUpcomingMovies(completion: @escaping () -> Void) {
        movieCategory = MovieCategory.Upcoming
        let url = getUrl(from: movieCategory!)
        guard let request = networkService.createRequest(url: url, method: .get) else { return }
        networkService.dataLoader.loadData(using: request) { (data, _, _) in
            guard let data = data else { return }
            let result = self.networkService.decode(to: MovieResult.self, data: data)
            guard let movieResult = result?.movies else { return }
            self.movies.append(contentsOf: [movieResult])
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    func fetchPopularMovies(completion: @escaping () -> Void) {
        movieCategory = MovieCategory.Popular
        let url = getUrl(from: movieCategory!)
        guard let request = networkService.createRequest(url: url, method: .get) else { return }
        networkService.dataLoader.loadData(using: request) { (data, _, _) in
            guard let data = data else { return }
            let result = self.networkService.decode(to: MovieResult.self, data: data)
            guard let movieResult = result?.movies else { return }
            self.movies.append(contentsOf: [movieResult])
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
