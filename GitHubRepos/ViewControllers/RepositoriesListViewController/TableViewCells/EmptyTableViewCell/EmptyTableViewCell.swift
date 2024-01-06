//
//  EmptyTableViewCell.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 28/10/2022.
//

import UIKit

/// Empty Table View Cell
class EmptyTableViewCell: UITableViewCell {

    /// Title label
    @IBOutlet private weak var titleLabel: UILabel!
    
    /**
     Awake from nib
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set selection style to none
        self.selectionStyle = .none
    }
    
    /**
     Setup
     - Parameter representable: Empty Table View Cell Representable
     */
    func setup(with representable: EmptyTableViewCellRepresentable) {
        
        // Set title label attributed text
        self.titleLabel.attributedText = representable.titleAttributedString
    }
    
    // MARK: - Class methods
    
    /**
     Get reuse identifier
     - Returns: String
     */
    class func getReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    /**
     Register
     - Parameter tableView: UITableView
     */
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: Bundle.main), forCellReuseIdentifier: Self.getReuseIdentifier())
    }
    
    /**
     Get height
     - Returns: CGFloat
     */
    class func getHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
}
