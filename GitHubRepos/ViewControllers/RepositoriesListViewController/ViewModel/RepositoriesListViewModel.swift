//
//  RepositoriesListViewModel.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

/// Repositories List View Model
class RepositoriesListViewModel {
    
    /// Representables
    private var representables: [TableViewCellRepresentable]
    
    /// Filtered representables
    private var filteredRepresentables: [TableViewCellRepresentable]
    
    /// Repositories
    private var repositories: [Repository]
    
    /// Search text
    private var searchText: String
    
    /// Next page number
    private(set) var nextPageNumber: Int
    
    /// Selected date
    private(set) var selectedDate: Date
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.representables = []
        self.filteredRepresentables = []
        self.repositories = []
        self.searchText = ""
        self.nextPageNumber = 1
        self.selectedDate = Date()
    }
    
    /**
     Build representables
     - Parameter index: Int
     - Parameter hasMoreData: Bool
     */
    private func buildRepresentables(from index: Int = 0, hasMoreData: Bool) {
        
        // Clear all representables if index is 0
        if index == 0 {
            self.representables.removeAll()
        }
        
        // Remove last representable if representables list is not empty
        else if !self.representables.isEmpty {
            self.representables.removeLast()
        }
        
        // Iterate over each repository
        for (itemIndex, repository) in self.repositories.enumerated() where index <= itemIndex {
            
            // Representable
            let representable = RepositoryTableViewCellRepresentable(repository: repository)
            
            // Set item data index
            representable.itemDataIndex = itemIndex
            
            // Append representable
            self.representables.append(representable)
        }
        
        // Add loading cell if we have a connection
        if NetworkingManager.shared.isNetworkReachable, !self.representables.isEmpty, hasMoreData {
            self.representables.append(LoadingTableViewCellRepresentable())
        }
        
        // Add empty cell if the list is empty
        if self.representables.isEmpty {
            self.representables = [EmptyTableViewCellRepresentable(title: NSLocalizedString("repositoriesListViewController.noDataYet.message", comment: ""))]
        }
        
        // Filter content
        self.filterContent(searchText: self.searchText)
    }
    
    /**
     Set data
     - Parameter repositories: [Repository]
     */
    func setData(repositories: [Repository]) {
        
        // Increment next page number
        self.nextPageNumber += 1
        
        // Current items count
        let currentItemsCount = self.repositories.count
        
        // Append new list
        self.repositories.append(contentsOf: repositories)
        
        // Has more data
        let hasMoreData = repositories.count >= RepositoriesModel.maximumItemsPerPage
        
        // Build representables
        self.buildRepresentables(from: currentItemsCount, hasMoreData: hasMoreData)
    }
    
    /**
     Update selected date
     - Parameter date: Date
     */
    func updateSelectedDate(date: Date) {
        self.selectedDate = date
    }
    
    /**
     Update repository
     - Parameter repository: Repository
     - Parameter indexPath: IndexPath
     */
    func updateRepository(repository: Repository, at indexPath: IndexPath) {
        
        // Update repository
        if let representable = self.representableForRow(at: indexPath) as? RepositoryTableViewCellRepresentable, representable.itemDataIndex < self.repositories.count {
            self.repositories[representable.itemDataIndex] = repository
        }
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
            self.filteredRepresentables = [EmptyTableViewCellRepresentable(title: String(format: NSLocalizedString("repositoriesListViewController.search.noResults.message", comment: ""), self.searchText))]
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
     Reset
     */
    func reset() {
        
        // Clear all data
        self.repositories.removeAll()
        self.representables.removeAll()
        self.filteredRepresentables.removeAll()
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
    
    /**
     Handle no internet connection
     - Returns: Bool
     */
    func handleNoInternetConnection() -> Bool {
        
        // Check if representables is empty or, first representable is loading cell or empty cell, then handle showing some info, because data is not appearing on view yet
        if self.representables.isEmpty || self.representables.first is LoadingTableViewCellRepresentable || self.representables.first is EmptyTableViewCellRepresentable {
        
            // Add empty cell with title
            self.representables = [EmptyTableViewCellRepresentable(title: NSLocalizedString("repositoriesListViewController.internetLost.message", comment: ""))]
            
            return true
        }
        
        return false
    }
    
    /**
     Handle internet connection back
     - Returns: Bool
     */
    func handleInternetConnectionBack() -> Bool {
        
        // Check if representables is empty or, first representable is loading cell or empty cell, then handle showing some info, because data is not appearing on view yet
        if self.representables.isEmpty || self.representables.first is LoadingTableViewCellRepresentable || self.representables.first is EmptyTableViewCellRepresentable {
            return true
        }
        
        return false
    }
}
