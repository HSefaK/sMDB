import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var poster: UIImageView!
    static let identifier = "MovieCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with movie: Movie) {
        guard let moviePoster = movie.poster else { return }
        guard let movieUrl = URL(string: Utils.baseImageUrl + moviePoster) else { return }
        poster.kf.setImage(with: movieUrl)
    }
    
}
