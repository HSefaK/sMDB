import Foundation

class SearchMovieController {
    var movies = [Movie]()
    
    private let networkService = NetworkService()
    
    var query = ""
    
    func getMovies(completion: @escaping () -> Void) {
        let stringUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(Utils.apiKey)&language=en-US&query=\(query)&page=1&include_adult=true"
        let url = URL(string: stringUrl)
        guard let request = networkService.createRequest(url: url, method: .get) else { return }
        networkService.dataLoader.loadData(using: request) { (data, _, _) in
            guard let data = data else { return }
            let result = self.networkService.decode(to: MovieResult.self, data: data)
            guard let movieResult = result?.movies else { return }
            self.movies.append(contentsOf: movieResult)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
