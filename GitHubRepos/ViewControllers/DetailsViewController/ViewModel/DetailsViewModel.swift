//
//  DetailsViewModel.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

/// Details View Model
class DetailsViewModel {
    
    private var representables: [TableViewCellRepresentable]
    
    private var repository: Repository
    
    init(repository: Repository) {
        self.representables = []
        self.repository = repository
        
        self.buildRepresentables()
    }
    
    private func buildRepresentables() {
        
        self.representables.removeAll()
        
        self.representables.append(DetailsTableViewCellRepresentable(repository: self.repository))
    }
    
    /**
     Number of rows
     */
    func numberOfRows(in section: Int) -> Int {
        return self.representables.count
    }
    
    /**
     Representable for row
     */
    func representableForRow(at indexPath: IndexPath) -> TableViewCellRepresentable? {
        
        // Check if the number of rows is valid
        if self.numberOfRows(in: indexPath.section) > indexPath.row {
            return self.representables[indexPath.row]
        }
        
        return nil
    }
    
    /**
     Height for representable
     */
    func heightForRepresentable(at indexPath: IndexPath, in tableView: UITableView) -> CGFloat {
        return self.representableForRow(at: indexPath)?.cellHeight ?? 0.0
    }
}
