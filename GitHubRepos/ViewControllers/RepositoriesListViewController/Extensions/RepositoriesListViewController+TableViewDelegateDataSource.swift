//
//  RepositoriesListViewController+TableViewDelegateDataSource.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

// MARK: - UITableViewDataSource
extension RepositoriesListViewController: UITableViewDataSource {
    
    /**
     Number of rows in section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(in: section)
    }
    
    /**
     Cell for row
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get loading table view cell representable
        if let representable = self.viewModel.representableForRow(at: indexPath) as? LoadingTableViewCellRepresentable {
        
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: representable.cellReuseIdentifier, for: indexPath) as! LoadingTableViewCell
            
            // Setup cell
            cell.setup(with: representable)
            
            return cell
        }
        
        // Get loading table view cell representable
        if let representable = self.viewModel.representableForRow(at: indexPath) as? EmptyTableViewCellRepresentable {
        
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: representable.cellReuseIdentifier, for: indexPath) as! EmptyTableViewCell
            
            // Setup cell
            cell.setup(with: representable)
            
            return cell
        }
        
        // Get user table view cell representable
        if let representable = self.viewModel.representableForRow(at: indexPath) as? RepositoryTableViewCellRepresentable {
            
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: representable.cellReuseIdentifier, for: indexPath) as! RepositoryTableViewCell
            
            // Setup cell
            cell.setup(with: representable)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    /**
     Will display cell
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Check if the cell is loading table view cell representable, then get users
        if self.viewModel.representableForRow(at: indexPath) is LoadingTableViewCellRepresentable {
            
            // Scroll to the bottom
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
            // Load repositories
            self.loadRepositories(for: self.viewModel.selectedDate, pageNumber: self.viewModel.nextPageNumber)
        }
    }
}

// MARK: - UITableViewDelegate
extension RepositoriesListViewController: UITableViewDelegate {
 
    /**
     Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.heightForRepresentable(at: indexPath, in: tableView)
    }
    
    /**
     Estimated height for row
     */
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    /**
     Did select row
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get repository
        if let repository = self.viewModel.didSelectRepresentable(at: indexPath) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController

            detailsViewController.repository = repository
            
            detailsViewController.delegate = self
            
            detailsViewController.indexPath = indexPath
            
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}

