//
//  DetailsTableViewCellRepresentable.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

/// Details Table View Cell Representable
class DetailsTableViewCellRepresentable: TableViewCellRepresentable {
    
    
    var cellReuseIdentifier: String
    
    var cellHeight: CGFloat
    
    var itemDataIndex: Int
    
    private(set) var userImageURL: String
    
    private(set) var detailsAttributedString: NSAttributedString
    
    private(set) var htmlURL: String
    
    init() {
        self.cellHeight = DetailsTableViewCell.getHeight()
        self.cellReuseIdentifier = DetailsTableViewCell.getRuseIdentifier()
        self.itemDataIndex = -1
        self.userImageURL = ""
        self.htmlURL = ""
        self.detailsAttributedString = NSAttributedString()
    }
    
    convenience init(repository: Repository) {
        self.init()
        
        self.userImageURL = repository.owner.imageURL
        
        self.htmlURL = repository.htmlURL
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = .current
        
        let detailsMutableAttributedString = NSMutableAttributedString()
        
        let titlesAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(1.0)]
        
        let valuesAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(1.0)]
        
        detailsMutableAttributedString.append(NSAttributedString(string: "Username: ", attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.owner.name, attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        
        detailsMutableAttributedString.append(NSAttributedString(string: "Repository name: ", attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.name, attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        
        detailsMutableAttributedString.append(NSAttributedString(string: "Star rating: ", attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.starsRate.description, attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        
        
        detailsMutableAttributedString.append(NSAttributedString(string: "Forks count: ", attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.forksCount.description, attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        
        
        detailsMutableAttributedString.append(NSAttributedString(string: "Creation date: ", attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: dateFormatter.string(from: repository.creationDate), attributes: valuesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        detailsMutableAttributedString.append(NSAttributedString(string: "URL: ", attributes: titlesAttributes))
        
        var htmlURLAttributes = valuesAttributes
        htmlURLAttributes[.link] = repository.htmlURL
        
        detailsMutableAttributedString.append(NSAttributedString(string: repository.htmlURL, attributes: htmlURLAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: "\n"))
        
        detailsMutableAttributedString.append(NSAttributedString(string: "Description: ", attributes: titlesAttributes))
        detailsMutableAttributedString.append(NSAttributedString(string: repository.description, attributes: valuesAttributes))
        
        
        self.detailsAttributedString = detailsMutableAttributedString
    }
}
