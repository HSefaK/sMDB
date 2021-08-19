import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerTitle: UILabel!
    
    static let identifier = "MovieTableViewCell"
    var movies = [Movie]()
    private lazy var favoriteMaker: FavoriteMaker = { return FavoriteMaker() }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(
            MovieCollectionViewCell.nib(),
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with models: [Movie], header: String) {
        self.movies = models
        self.headerTitle.text = header
        collectionView.reloadData()
    }
    
}

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.identifier,
            for: indexPath
        ) as? MovieCollectionViewCell
        cell?.configure(with: movies[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tabBarCon = self.window?.rootViewController as? UITabBarController
        let navCon = tabBarCon?.viewControllers![0] as? UINavigationController
        
        if let moviesVC = navCon?.visibleViewController as? MoviesViewController {
            let detailMovieVC = DetailMovieViewController(nibName: "DetailMovieViewController", bundle: nil)
            let movieId = movies[indexPath.row].id
            detailMovieVC.detailMovieController.movieId = movieId
            detailMovieVC.isInFavorites = favoriteMaker.checkData(movieId)
            moviesVC.navigationController?.pushViewController(detailMovieVC, animated: true)
        }
    }
}
