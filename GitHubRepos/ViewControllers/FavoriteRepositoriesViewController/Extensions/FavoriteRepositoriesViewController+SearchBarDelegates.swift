//
//  FavoriteRepositoriesViewController+SearchBarDelegates.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

// MARK: - Search Bar Delegate
extension FavoriteRepositoriesViewController: UISearchBarDelegate {
    
    /**
     Text did change
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        // Filter content
        self.viewModel.setSearchText(text: searchText)
        
        // Reload table view data
        self.tableView.reloadData()
    }
    
    /**
     Search button clicked
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Force end editing the view, in order to dismiss the keyboard
        self.view.endEditing(true)
    }
}


