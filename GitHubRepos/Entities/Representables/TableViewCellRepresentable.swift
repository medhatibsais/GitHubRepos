//
//  TableViewCellRepresentable.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

protocol TableViewCellRepresentable {
    
    var cellReuseIdentifier: String { get set }
    
    var cellHeight: CGFloat { get set }
    
    var itemDataIndex: Int { get set }
}
