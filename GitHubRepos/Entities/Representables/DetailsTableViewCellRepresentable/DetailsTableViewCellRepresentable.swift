//
//  DetailsTableViewCellRepresentable.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

/// Details Table View Cell Representable
class DetailsTableViewCellRepresentable: TableViewCellRepresentable {
    
    /// Cell height
    var cellHeight: CGFloat
    
    /// Cell reuse identifier
    var cellReuseIdentifier: String
    
    /// Item data index
    var itemDataIndex: Int
    
    /// User image URL
    private(set) var userImageURL: String
    
    /// Details attributed string
    private(set) var detailsAttributedString: NSAttributedString
    
    /// html URL
    private(set) var htmlURL: String
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.cellHeight = DetailsTableViewCell.getHeight()
        self.cellReuseIdentifier = DetailsTableViewCell.getRuseIdentifier()
        self.itemDataIndex = -1
        self.userImageURL = ""
        self.htmlURL = ""
        self.detailsAttributedString = NSAttributedString()
    }
    
    /**
     Initializer
     - Parameter repository: Repository
     */
    convenience init(repository: Repository) {
        self.init()
        
        // Set user image URL
        self.userImageURL = repository.owner.imageURL
        
        // Set html URL
        self.htmlURL = repository.htmlURL
        
        // Date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = .current
        
        // Details mutable attributed string
        let detailsMutableAttributedString = NSMutableAttributedString()
        
        // Titles attributes
        let titlesAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(1.0)]
        
        // Values attributes
        let valuesAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(1.0)]
        
        // Add user name
        detailsMutableAttributedString.append(NSAttributedString(string: NSLocalizedString("general.username", comment: ""), attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.owner.name, attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        // Add repository name
        detailsMutableAttributedString.append(NSAttributedString(string: NSLocalizedString("general.repository.name", comment: ""), attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.name, attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        // Add stars rate
        detailsMutableAttributedString.append(NSAttributedString(string: NSLocalizedString("general.repository.starsRate", comment: ""), attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.starsRate.description, attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        // Add forks count
        detailsMutableAttributedString.append(NSAttributedString(string: NSLocalizedString("general.repository.forksCount", comment: ""), attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.forksCount.description, attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        // Add creation date
        detailsMutableAttributedString.append(NSAttributedString(string: NSLocalizedString("general.repository.creationDate", comment: ""), attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: dateFormatter.string(from: repository.creationDate), attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        // Add URL
        detailsMutableAttributedString.append(NSAttributedString(string: NSLocalizedString("general.repository.htmlURL", comment: ""), attributes: titlesAttributes))
        
        // URL attributes
        var htmlURLAttributes = valuesAttributes
        htmlURLAttributes[.link] = repository.htmlURL
        
        detailsMutableAttributedString.append(NSAttributedString(string: repository.htmlURL, attributes: htmlURLAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        // Add description
        detailsMutableAttributedString.append(NSAttributedString(string: NSLocalizedString("general.repository.description", comment: ""), attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.description, attributes: valuesAttributes))
        
        // Set details attributed string
        self.detailsAttributedString = detailsMutableAttributedString
    }
}
