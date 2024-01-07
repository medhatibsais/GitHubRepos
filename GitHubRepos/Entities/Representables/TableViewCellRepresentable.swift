//
//  TableViewCellRepresentable.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

/// Table View Cell Representable
protocol TableViewCellRepresentable {
    
    /// Cell reuse identifier
    var cellReuseIdentifier: String { get set }
    
    /// Cell height
    var cellHeight: CGFloat { get set }
    
    /// Item data index
    var itemDataIndex: Int { get set }
}
