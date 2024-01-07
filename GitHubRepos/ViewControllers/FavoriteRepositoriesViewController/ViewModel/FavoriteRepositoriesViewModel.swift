//
//  FavoriteRepositoriesViewModel.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit
import Combine

/// Favorite Repositories View Model
class FavoriteRepositoriesViewModel {
    
    /// Representables
    private var representables: [TableViewCellRepresentable]
    
    /// Filtered representables
    private var filteredRepresentables: [TableViewCellRepresentable]
    
    /// Repositories
    private var repositories: [Repository]
    
    /// Search text
    private var searchText: String
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.representables = []
        self.filteredRepresentables = []
        self.repositories = []
        self.searchText = ""

        // Build representables
        self.buildRepresentables()
    }
    
    /**
     Build representables
     */
    private func buildRepresentables() {
        
        // Clear all representables
        self.representables.removeAll()
        
        // Iterate over each repository
        for (itemIndex, repository) in self.repositories.enumerated() {
            
            // Representable
            let representable = RepositoryTableViewCellRepresentable(repository: repository)
            
            // Set item data index
            representable.itemDataIndex = itemIndex
            
            // Append to list
            self.representables.append(representable)
        }
        
        // Add empty cell if the list is empty
        if self.representables.isEmpty {
            self.representables = [EmptyTableViewCellRepresentable(title: NSLocalizedString("favoriteRepositoriesViewController.noDataYet.message", comment: ""))]
        }
        
        // Filter content
        self.filterContent(searchText: self.searchText)
    }
    
    /**
     Set data
     - Parameter repositories: [Repository]
     */
    func setData(repositories: [Repository]) {
        
        // Set repositories
        self.repositories = repositories
        
        // Build representables
        self.buildRepresentables()
    }
    
    /**
     Set search text
     - Parameter text: String
     */
    func setSearchText(text: String) {
        
        // Set search text
        self.searchText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Filter content
        self.filterContent(searchText: self.searchText)
    }
    
    /**
     Filter content
     - Parameter searchText: String
     */
    private func filterContent(searchText: String) {
        
        // Check if text is not empty
        guard !self.searchText.isEmpty else { return }
        
        // Get filtered representables
        self.filteredRepresentables = self.representables.filter({ ($0 as? RepositoryTableViewCellRepresentable)?.search(text: searchText) ?? false })
        
        // Add empty cell if the list is empty
        if self.filteredRepresentables.isEmpty {
            self.filteredRepresentables = [EmptyTableViewCellRepresentable(title: String(format: NSLocalizedString("favoriteRepositoriesViewController.search.noResults.message", comment: ""), self.searchText))]
        }
    }
    
    /**
     Get user
     - Parameter indexPath: IndexPath
     - Returns: Optional user
     */
    private func getRepository(at indexPath: IndexPath) -> Repository? {
        
        // Get representable
        if let representable = self.representableForRow(at: indexPath) as? RepositoryTableViewCellRepresentable, representable.itemDataIndex < self.repositories.count {
            return self.repositories[representable.itemDataIndex]
        }
        
        return nil
    }
    
    /**
     Number of rows
     */
    func numberOfRows(in section: Int) -> Int {
        return self.searchText.isEmpty ? self.representables.count : self.filteredRepresentables.count
    }
    
    /**
     Representable for row
     */
    func representableForRow(at indexPath: IndexPath) -> TableViewCellRepresentable? {
        
        // Check if the number of rows is valid
        if self.numberOfRows(in: indexPath.section) > indexPath.row {
            
            // Check if we have search text
            if self.searchText.isEmpty {
                return self.representables[indexPath.row]
            }
            else {
                return self.filteredRepresentables[indexPath.row]
            }
        }
        
        return nil
    }
    
    /**
     Height for representable
     */
    func heightForRepresentable(at indexPath: IndexPath, in tableView: UITableView) -> CGFloat {
        
        // Representable
        let representable = self.representableForRow(at: indexPath)
        
        // Check if the representable is empty table view cell representable
        if representable is EmptyTableViewCellRepresentable {
            return tableView.frame.size.height
        }
        
        return representable?.cellHeight ?? 0.0
    }
    
    /**
     Did select representable
     */
    func didSelectRepresentable(at indexPath: IndexPath) -> Repository? {
        return self.getRepository(at: indexPath)
    }
}
