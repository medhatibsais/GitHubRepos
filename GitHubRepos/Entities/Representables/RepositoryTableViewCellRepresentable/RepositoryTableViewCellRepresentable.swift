//
//  RepositoryTableViewCellRepresentable.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

/// Repository Table View Cell Representable
class RepositoryTableViewCellRepresentable: TableViewCellRepresentable, Searchable {
    
    /// Cell height
    var cellHeight: CGFloat
    
    /// Cell reuse identifier
    var cellReuseIdentifier: String
    
    /// Item data index
    var itemDataIndex: Int
    
    /// User image URL
    private(set) var userImageURL: String
    
    /// Repository name
    private(set) var repositoryName: String
    
    /// Details attributed string
    private(set) var detailsAttributedString: NSAttributedString
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.cellHeight = RepositoryTableViewCell.getHeight()
        self.cellReuseIdentifier = RepositoryTableViewCell.getRuseIdentifier()
        self.itemDataIndex = -1
        self.userImageURL = ""
        self.repositoryName = ""
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
        
        // Set repository name
        self.repositoryName = repository.name
        
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
        
        // Add description
        detailsMutableAttributedString.append(NSAttributedString(string: NSLocalizedString("general.repository.description", comment: ""), attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.description, attributes: valuesAttributes))
        
        // Set details attributed string
        self.detailsAttributedString = detailsMutableAttributedString
    }
    
    /**
     Search
     - Parameter text: String
     - Returns: Bool, to indicate that the provided search text is exists in the user name string
     */
    func search(text: String) -> Bool {
        return self.repositoryName.lowercased().contains(text.lowercased())
    }
}
