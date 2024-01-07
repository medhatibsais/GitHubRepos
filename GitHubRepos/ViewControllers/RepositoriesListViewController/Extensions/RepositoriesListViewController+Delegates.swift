//
//  RepositoriesListViewController+Delegates.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

// MARK: - Search Bar Delegate
extension RepositoriesListViewController: UISearchBarDelegate {
    
    /**
     Text did change
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        // Filter content
        self.viewModel.setSearchText(text: searchText)
        
        // Reload table view data
        self.reloadTableViewData()
    }
    
    /**
     Search button clicked
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Force end editing the view, in order to dismiss the keyboard
        self.view.endEditing(true)
    }
}

// MARK: - Details View Controller Delegate
extension RepositoriesListViewController: DetailsViewControllerDelegate {
    
    /**
     Did update favorite status for
     - Parameter repository: Repository
     - Parameter indexPath: IndexPath
     */
    func detailsViewController(didUpdateFavoriteStatusFor repository: Repository, at indexPath: IndexPath) {
        
        // Update repository
        self.viewModel.updateRepository(repository: repository, at: indexPath)
    }
}

