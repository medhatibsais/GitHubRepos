//
//  EmptyTableViewCellRepresentable.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 28/10/2022.
//

import UIKit

/// Empty Table View Cell Representable
class EmptyTableViewCellRepresentable: TableViewCellRepresentable {
    
    /// Cell height
    var cellHeight: CGFloat
    
    /// Cell reuse identifier
    var cellReuseIdentifier: String
    
    /// Item data index
    var itemDataIndex: Int
    
    /// Title attributed string
    private(set) var titleAttributedString: NSAttributedString
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.cellHeight = EmptyTableViewCell.getHeight()
        self.cellReuseIdentifier = EmptyTableViewCell.getReuseIdentifier()
        self.itemDataIndex = -1
        self.titleAttributedString = NSAttributedString()
    }
    
    /**
     Initializer
     - Parameter title: String
     */
    convenience init(title: String) {
        self.init()
        
        // Paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // Set title attributed string
        self.titleAttributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0), NSAttributedString.Key.foregroundColor: UIColor.black, .paragraphStyle: paragraphStyle])
    }
}
