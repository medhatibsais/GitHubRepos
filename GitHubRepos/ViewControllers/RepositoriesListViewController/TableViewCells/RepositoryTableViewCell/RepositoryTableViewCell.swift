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
    
    /// Details label
    @IBOutlet private weak var detailsLabel: UILabel!
    
    /**
     Awake from nib
     */
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Set selection style to none
        self.selectionStyle = .none
        
        // Set number of lines to 10
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
    
    /**
     Setup
     - Parameter representable: Repository Table View Cell Representable
     */
    func setup(with representable: RepositoryTableViewCellRepresentable) {
        
        // Load image from URL
        if !representable.userImageURL.isEmpty, let url = URL(string: representable.userImageURL) {
            self.userProfileImage.sd_setImage(with: url)
        }
        
        // Set attributed text
        self.detailsLabel.attributedText = representable.detailsAttributedString
    }
    
    // MARK: - Class methods
    
    /**
     Get height
     - Returns: CGFloat
     */
    class func getHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /**
     Get ruse identifier
     - Returns: String
     */
    class func getRuseIdentifier() -> String {
        return String(describing: self)
    }
    
    /**
     Register
     - Parameter tableView: UITableView
     */
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: Bundle.main), forCellReuseIdentifier: Self.getRuseIdentifier())
    }
}
