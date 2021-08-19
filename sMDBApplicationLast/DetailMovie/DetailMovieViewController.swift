import UIKit
import Kingfisher

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedView: UIView!
    
    let detailMovieController = DetailMovieController()
    private var views = [UIView]()
    private lazy var favoriteMaker: FavoriteMaker = { return FavoriteMaker() }()
    var isInFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewManager()
        setSegmentedViewAppear()
    }
    
    private func configure(with movie: DetailMovie) {
        movieTitle.text = movie.title
        rating.text = "\(movie.rating)/10"
        releaseDate.text = Utils.formatDate(from: movie.releaseDate)
        
        if let posterUrl = movie.posterUrl {
            poster.kf.setImage(with: URL(string: Utils.baseImageUrl + posterUrl))
        }
        if let backdropUrl = movie.backdropUrl {
            backdrop.kf.setImage(with: URL(string: Utils.baseImageUrl + backdropUrl))
        }
        
        var genresArr = [String]()
        for genre in movie.genres {
            genresArr.append(genre.name)
        }
        genres.text = genresArr.joined(separator: ", ")
    }
    
    private func viewManager() {
        let addToFavoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(addToFavorites))
        let removeFromFavoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart.fill"),
            style: .plain, target: self, action: #selector(removeFromFavorites))
        if isInFavorites {
            self.navigationItem.rightBarButtonItem = removeFromFavoritesButton
        } else {
            self.navigationItem.rightBarButtonItem = addToFavoritesButton
        }
        
        activityIndicator.startAnimating()
        
        let overviewVC = OverviewViewController()
        let reviewsVC = setupReviewsVC()
        
        detailMovieController.fetchMovie {
            if let movie = self.detailMovieController.movie {
                self.configure(with: movie)
                overviewVC.overview.text = movie.overview
                self.activityIndicator.stopAnimating()
            }
        }
        views.append(overviewVC.view)
        views.append(reviewsVC.view)
        for viewControllerView in views {
            segmentedView.addSubview(viewControllerView)
        }
    }
    
    private func setupReviewsVC() -> UIViewController {
        let reviewsVC = ReviewsViewController()
        detailMovieController.fetchReviews {
            reviewsVC.tableView.register(
                ReviewTableViewCell.nib(),
                forCellReuseIdentifier: ReviewTableViewCell.identifier
            )
            reviewsVC.tableView.dataSource = self
            reviewsVC.tableView.delegate = self
            reviewsVC.tableView.reloadData()
        }
        return reviewsVC
    }
    @objc private func addToFavorites() {
        let movie = detailMovieController.movie
        favoriteMaker.makeFavorite(
            movie!.id,
            movieTitle.text!,
            (backdrop.image?.jpegData(compressionQuality: 0.0))!,
            (poster.image?.jpegData(compressionQuality: 0.0))!,
            (movie?.overview)!,
            releaseDate.text!,
            rating.text!,
            genres.text ?? "") {
            DispatchQueue.main.async {
                self.isInFavorites.toggle()
                self.setButtonBackGround(
                    view: self.navigationItem.rightBarButtonItem!,
                    on: UIImage(systemName: "suit.heart.fill")!,
                    off: UIImage(systemName: "suit.heart")!,
                    onOffStatus: self.isInFavorites
                )
                let alert = UIAlertController(
                    title: "Added to Favorites",
                    message: "Movie has been added to favorites.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @objc private func removeFromFavorites() {
        guard let id = detailMovieController.movie?.id else { return }
        favoriteMaker.removeFromFavorite(id) {
            DispatchQueue.main.async {
                self.isInFavorites.toggle()
                self.setButtonBackGround(
                    view: self.navigationItem.rightBarButtonItem!,
                    on: UIImage(systemName: "suit.heart.fill")!,
                    off: UIImage(systemName: "suit.heart")!,
                    onOffStatus: self.isInFavorites
                )
                let alert = UIAlertController(
                    title: "Removed",
                    message: "Movie has been removed from favorites.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        setSegmentedViewAppear()
    }
    
    private func setSegmentedViewAppear() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segmentedView.bringSubviewToFront(views[0])
        case 1:
            segmentedView.bringSubviewToFront(views[1])
        default:
            return
        }
    }
    private func setButtonBackGround(view: UIBarButtonItem, on: UIImage, off: UIImage, onOffStatus: Bool ) {
        switch onOffStatus {
        case true:
            view.image = UIImage(systemName: "suit.heart.fill")
        case false:
            view.image = UIImage(systemName: "suit.heart")
        }
    }
}

extension DetailMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailMovieController.reviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ReviewTableViewCell.identifier,
            for: indexPath
        ) as? ReviewTableViewCell
        cell?.configure(with: detailMovieController.reviews[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(130.0)
    }
}
