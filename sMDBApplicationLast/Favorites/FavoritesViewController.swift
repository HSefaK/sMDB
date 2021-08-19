import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private lazy var favoriteMaker: FavoriteMaker = { return FavoriteMaker() }()
    var favorites = [Favorite]()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadFavorites()
    }
    private func viewManager() {
        tableView.register(FavoritesTableViewCell.nib(), forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func loadFavorites() {
        activityIndicator.startAnimating()        
        favoriteMaker.getFavorites { (favorites) in
            DispatchQueue.main.async {
                self.favorites = favorites
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }

}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoritesTableViewCell.identifier,
            for: indexPath
        ) as? FavoritesTableViewCell
        cell?.configure(with: favorites[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMovieVC = DetailMovieViewController(nibName: "DetailMovieViewController", bundle: nil)
        let movieId = favorites[indexPath.row].id
        detailMovieVC.detailMovieController.movieId = movieId
        if let id = movieId {
            detailMovieVC.isInFavorites = favoriteMaker.checkData(id)
            navigationController?.pushViewController(detailMovieVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(170.0)
    }
}
