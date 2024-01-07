//
//  FavoriteRepositoriesViewController+TableViewDelegateDataSource.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

// MARK: - UITableViewDataSource
extension FavoriteRepositoriesViewController: UITableViewDataSource {
    
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
}

// MARK: - UITableViewDelegate
extension FavoriteRepositoriesViewController: UITableViewDelegate {
 
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
        // Get repository
        if let repository = self.viewModel.didSelectRepresentable(at: indexPath) {
            
            // Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            // Create details view controller
            let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController

            // Set repository
            detailsViewController.repository = repository
            
            // Set delegate
            detailsViewController.delegate = self
            
            // Set indexPath
            detailsViewController.indexPath = indexPath
            
            // Push view controller
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}


