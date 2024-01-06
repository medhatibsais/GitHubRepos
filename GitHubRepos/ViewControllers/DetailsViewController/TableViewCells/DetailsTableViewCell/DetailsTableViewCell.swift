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
    
    @IBOutlet private weak var profileImageView: UIImageView!
    
    @IBOutlet private weak var detailsLabel: UILabel!
    
    private var htmlURL: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.detailsLabel.isUserInteractionEnabled = true
    }
    
    func setup(with representable: DetailsTableViewCellRepresentable) {
        
        self.htmlURL = representable.htmlURL
        
        if !representable.userImageURL.isEmpty, let url = URL(string: representable.userImageURL) {
            
            self.profileImageView.sd_setImage(with: url)
        }
        
        self.detailsLabel.attributedText = representable.detailsAttributedString
        
        self.detailsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didClickOnLabel(_:))))
        
    }
    
    @objc private func didClickOnLabel(_ gestureRecognizer: UITapGestureRecognizer) {
        
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
        
        if NSLocationInRange(indexOfCharacter, textRange), let url = URL(string: self.htmlURL), UIApplication.shared.canOpenURL(url) {
            
            UIApplication.shared.open(url)
        }
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
