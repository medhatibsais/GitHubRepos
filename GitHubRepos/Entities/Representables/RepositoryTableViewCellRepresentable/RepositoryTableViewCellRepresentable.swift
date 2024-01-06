//
//  RepositoryTableViewCellRepresentable.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

class RepositoryTableViewCellRepresentable: TableViewCellRepresentable, Searchable {
    
    var cellReuseIdentifier: String
    
    var cellHeight: CGFloat
    
    var itemDataIndex: Int
    
    private(set) var userImageURL: String
    
    private(set) var repositoryName: String
    
    private(set) var detailsAttributedString: NSAttributedString
    
    init() {
        self.cellHeight = RepositoryTableViewCell.getHeight()
        self.cellReuseIdentifier = RepositoryTableViewCell.getRuseIdentifier()
        self.itemDataIndex = -1
        self.userImageURL = ""
        self.repositoryName = ""
        self.detailsAttributedString = NSAttributedString()
    }
    
    convenience init(repository: Repository) {
        self.init()
        
        self.userImageURL = repository.owner.imageURL
        
        self.repositoryName = repository.name
        
        let detailsString = "username: " + repository.owner.name + "\n" + "repository name: " + repository.name  + "\n" + "Star rating: " + repository.starsRate.description + "\n" + "description: " + repository.description
        
        self.detailsAttributedString = NSAttributedString(string: detailsString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(1.0)])
        
    }
    
    func search(text: String) -> Bool {
        return self.repositoryName.lowercased().contains(text.lowercased())
    }
}
