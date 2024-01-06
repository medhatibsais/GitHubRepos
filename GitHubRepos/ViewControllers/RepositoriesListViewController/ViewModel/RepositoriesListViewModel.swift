//
//  RepositoriesListViewModel.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

/// Repositories List View Model
class RepositoriesListViewModel {
    
    private var representables: [TableViewCellRepresentable]
    
    private var filteredRepresentables: [TableViewCellRepresentable]
    
    private var repositories: [Repository]
    
    private var searchText: String
    
    private(set) var nextPageNumber: Int
    
    private(set) var selectedDate: Date
    
    init() {
        self.representables = []
        self.filteredRepresentables = []
        self.repositories = []
        self.searchText = ""
        self.nextPageNumber = 1
        self.selectedDate = Date()
    }
    
    private func buildRepresentables(from index: Int = 0, hasMoreData: Bool) {
        
        if index == 0 {
         
            self.representables.removeAll()
        }
        else if !self.representables.isEmpty {
            self.representables.removeLast()
        }
        
        for (itemIndex, repository) in self.repositories.enumerated() where index <= itemIndex {
            
            let representable = RepositoryTableViewCellRepresentable(repository: repository)
            
            representable.itemDataIndex = itemIndex
            
            self.representables.append(representable)
        }
        
        // Add loading cell if we have a connection
        if SystemUtils.isNetworkReachable, !self.representables.isEmpty, hasMoreData {
            self.representables.append(LoadingTableViewCellRepresentable())
        }
        
        // Add empty cell if the list is empty
        if self.representables.isEmpty {
            self.representables = [EmptyTableViewCellRepresentable(title: NSLocalizedString("usersListViewController.noUsersYet", comment: ""))]
        }
        
        self.filterContent(searchText: self.searchText)
    }
    
    func setData(repositories: [Repository]) {
        
        self.nextPageNumber += 1
        
        let currentItemsCount = self.repositories.count
        
        self.repositories.append(contentsOf: repositories)
        
        let hasMoreData = repositories.count >= RepositoriesModel.maximumItemsPerPage
        
        self.buildRepresentables(from: currentItemsCount, hasMoreData: hasMoreData)
    }
    
    func updateSelectedDate(date: Date) {
        self.selectedDate = date
    }
    
    func updateRepository(repository: Repository, at indexPath: IndexPath) {
        
        // Get representable
        if let representable = self.representableForRow(at: indexPath) as? RepositoryTableViewCellRepresentable, representable.itemDataIndex < self.repositories.count {
            self.repositories[representable.itemDataIndex] = repository
        }
    }
    
    
    func setSearchText(text: String) {
        
        self.searchText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.filterContent(searchText: self.searchText)
    }
    
    private func filterContent(searchText: String) {
        
        guard !self.searchText.isEmpty else { return }
        
        self.filteredRepresentables = self.representables.filter({ ($0 as? RepositoryTableViewCellRepresentable)?.search(text: searchText) ?? false })
        
        // Add empty cell if the list is empty
        if self.filteredRepresentables.isEmpty {
            self.filteredRepresentables = [EmptyTableViewCellRepresentable(title: String(format: NSLocalizedString("usersListViewController.search.noResults", comment: ""), self.searchText))]
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
    
    func reset() {
        
        self.repositories.removeAll()
        self.representables.removeAll()
        self.filteredRepresentables.removeAll()
        self.searchText = ""
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