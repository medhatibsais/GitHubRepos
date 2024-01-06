//
//  RepositoryTableViewCell.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit
import SDWebImage

/// Repository Table View Cell
class RepositoryTableViewCell: UITableViewCell {

    /// User profile image
    @IBOutlet private weak var userProfileImage: UIImageView!
    
    @IBOutlet private weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.selectionStyle = .none
        
        self.detailsLabel.numberOfLines = 10
    }
    
    /**
     Draw
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Round user profile image
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.bounds.size.height / 2
        self.userProfileImage.clipsToBounds = true
    }
    
    func setup(with representable: RepositoryTableViewCellRepresentable) {
        
        if !representable.userImageURL.isEmpty, let url = URL(string: representable.userImageURL) {
         
            self.userProfileImage.sd_setImage(with: url)
        }
        
        self.detailsLabel.attributedText = representable.detailsAttributedString
    }
    
    // MARK: - Class methods
    
    class func getHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    class func getRuseIdentifier() -> String {
        return String(describing: self)
    }
    
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: Bundle.main), forCellReuseIdentifier: Self.getRuseIdentifier())
    }
}
