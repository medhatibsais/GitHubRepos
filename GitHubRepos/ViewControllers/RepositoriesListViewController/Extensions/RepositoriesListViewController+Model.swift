//
//  RepositoriesListViewController+Model.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import Foundation

extension RepositoriesListViewController {
    
    func loadRepositories(for date: Date, pageNumber: Int = 1) {
        
        RepositoriesModel.search(date: date, order: .descending, sortBy: .stars, pageNumber: pageNumber) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let repositories):
                
                self.viewModel.setData(repositories: repositories)
                
                self.tableView.reloadData()
                
            case .failure(let error):
                
                SystemUtils.showMessageAlert(title: "Error", message: error.localizedDescription)
            }
            
            self.showLoadingView(false)
        }
    }
}
