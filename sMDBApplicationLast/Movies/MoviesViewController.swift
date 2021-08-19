import UIKit


class MoviesViewController: UIViewController {
    
    @IBOutlet weak var movieTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let moviesController = MoviesController()
    private let headerTitle = ["Now Playing", "Upcoming", "Top Rated"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTable.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        movieTable.dataSource = self
        movieTable.delegate = self
        getMovies()
    }
    
    private func getMovies() {
        activityIndicator.startAnimating()
        moviesController.fetchNowPlayingMovies {
            self.movieTable.reloadData()
            
            self.moviesController.fetchUpcomingMovies {
                self.movieTable.reloadData()
                
                self.moviesController.fetchPopularMovies {
                    self.movieTable.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }   
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesController.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell
        cell?.configure(with: moviesController.movies[indexPath.row], header: headerTitle[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentInset.left
        if position > (movieTable.contentInset.left){
            print("dataaa")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280.0
    }
}


