import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewBody: UILabel!
    
    static let identifier = "ReviewTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with review: Review) {
        self.reviewBody.text = review.content
    }
    
}
