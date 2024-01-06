//
//  LoadingTableViewCellRepresentable.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// Loading Table View Cell Representable
class LoadingTableViewCellRepresentable: TableViewCellRepresentable {
    
    /// Cell height
    var cellHeight: CGFloat
    
    /// Cell reuse identifier
    var cellReuseIdentifier: String
    
    /// Item data index
    var itemDataIndex: Int
    
    /// Loading indicator color
    var loadingIndicatorColor: UIColor
    
    /// Loading indicator background color
    var loadingIndicatorBackgroundColor: UIColor
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.cellHeight = LoadingTableViewCell.getHeight()
        self.cellReuseIdentifier = LoadingTableViewCell.getReuseIdentifier()
        self.itemDataIndex = -1
        self.loadingIndicatorColor = .blue
        self.loadingIndicatorBackgroundColor = .clear
    }
}
