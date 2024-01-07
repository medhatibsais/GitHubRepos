//
//  RepositoriesListViewController+Model.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import Foundation

extension RepositoriesListViewController {
    
    /**
     Load repositories
     - Parameter date: Date
     - Parameter pageNumber: Int
     */
    func loadRepositories(for date: Date, pageNumber: Int = 1) {
        
        // Search
        RepositoriesModel.search(date: date, order: .descending, sortBy: .stars, pageNumber: pageNumber) { [weak self] result in
            
            // self
            guard let self = self else { return }
            
            switch result {
            case .success(let repositories):
                
                // Set data
                self.viewModel.setData(repositories: repositories)
                
                // Reload table view
                self.tableView.reloadData()
                
            case .failure(let error):
                
                // Show alert message
                SystemUtils.showMessageAlert(title: NSLocalizedString("repositoriesListViewController.alert.loadingFailure.title", comment: ""), message: error.localizedDescription)
            }
            
            // Hide loading
            self.showLoadingView(false)
            
            // Enable right bar button item
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
