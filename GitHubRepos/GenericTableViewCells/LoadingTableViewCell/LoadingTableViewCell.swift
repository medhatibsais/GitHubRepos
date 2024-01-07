//
//  LoadingTableViewCell.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// Loading Table View Cell
class LoadingTableViewCell: UITableViewCell {

    /// Loading indicator
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
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
     - Parameter representable: Loading Table View Cell Representable
     */
    func setup(with representable: LoadingTableViewCellRepresentable) {
        
        // Start animating
        self.loadingIndicator.startAnimating()
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
        return 70.0
    }
}
