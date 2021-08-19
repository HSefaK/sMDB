import UIKit

class SearchMovieViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let searchMovieController = SearchMovieController()
    private lazy var favoriteMaker: FavoriteMaker = { return FavoriteMaker() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        viewManager()
    }
    
    private func viewManager() {
        tableView.register(SearchMovieTableViewCell.nib(), forCellReuseIdentifier: SearchMovieTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        self.tableView.separatorStyle = .none
    }
}
extension SearchMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMovieController.movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchMovieTableViewCell.identifier,
            for: indexPath) as? SearchMovieTableViewCell
        cell?.configure(with: searchMovieController.movies[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.height){
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMovieVC = DetailMovieViewController()
        let movieId = searchMovieController.movies[indexPath.row].id
        detailMovieVC.detailMovieController.movieId = movieId
        detailMovieVC.isInFavorites = favoriteMaker.checkData(movieId)
        navigationController?.pushViewController(detailMovieVC, animated: true)
    }
    
}

extension SearchMovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            tableView.separatorStyle = .none
            activityIndicator.stopAnimating()
            searchMovieController.movies.removeAll()
            tableView.reloadData()
        } else {
            searchMovieController.movies.removeAll()
            searchMovieController.query = searchText.replacingOccurrences(of: " ", with: "%20")
            activityIndicator.startAnimating()
            searchMovieController.getMovies {
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
        }
    }
}
