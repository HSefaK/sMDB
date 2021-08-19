import UIKit
import Kingfisher

class SearchMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    static let identifier = "SearchMovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with movie: Movie) {
        self.movieTitle.text = movie.title
        self.releaseDate.text = Utils.formatDate(from: movie.releaseDate)
        self.rating.text = "\(movie.rating)/10"
        guard let moviePoster = movie.poster else { return }
        guard let movieUrl = URL(string: Utils.baseImageUrl + moviePoster) else { return }
        poster.kf.setImage(with: movieUrl)
    }
    
}
