//
//  DetailsTableViewCell.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit
import SDWebImage

/// Details Table View Cell
class DetailsTableViewCell: UITableViewCell {
    
    /// Profile image view
    @IBOutlet private weak var profileImageView: UIImageView!
    
    /// Details label
    @IBOutlet private weak var detailsLabel: UILabel!
    
    /// html URL
    private var htmlURL: String!
    
    /**
     Awake from nib
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set selection style to none
        self.selectionStyle = .none
        
        // Enable user interaction
        self.detailsLabel.isUserInteractionEnabled = true
    }
    
    /**
     Setup
     - Parameter representable: Details Table View Cell Representable
     */
    func setup(with representable: DetailsTableViewCellRepresentable) {
        
        // Set html URL
        self.htmlURL = representable.htmlURL
        
        // Get image URL
        if !representable.userImageURL.isEmpty, let url = URL(string: representable.userImageURL) {
            self.profileImageView.sd_setImage(with: url)
        }
        
        // Set attributed text
        self.detailsLabel.attributedText = representable.detailsAttributedString
        
        // Add tab gesture
        self.detailsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didClickOnLabel(_:))))
    }
    
    /**
     Did click on label
     - Parameter gestureRecognizer: UI Tap Gesture Recognizer
     */
    @objc private func didClickOnLabel(_ gestureRecognizer: UITapGestureRecognizer) {
        
        // Text range
        let textRange = (self.detailsLabel.text! as NSString).range(of: self.htmlURL)
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: self.detailsLabel.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = self.detailsLabel.lineBreakMode
        textContainer.maximumNumberOfLines = self.detailsLabel.numberOfLines
        let labelSize = self.detailsLabel.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = gestureRecognizer.location(in: self.detailsLabel)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // Check if the touch location is in range of the URL text
        if NSLocationInRange(indexOfCharacter, textRange) {
            
            // Check if the URL can be opened
            if let url = URL(string: self.htmlURL), UIApplication.shared.canOpenURL(url) {
             
                // Open URL
                UIApplication.shared.open(url)
            }
            else {
                
                // Show alert message
                SystemUtils.showMessageAlert(title: NSLocalizedString("detailsViewController.error.invalidURL.alert.title", comment: ""), message: NSLocalizedString("detailsViewController.error.invalidURL.alert.message", comment: ""))
            }
        }
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
