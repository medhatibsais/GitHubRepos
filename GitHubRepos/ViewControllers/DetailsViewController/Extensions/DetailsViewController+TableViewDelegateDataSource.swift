//
//  DetailsViewController+TableViewDelegateDataSource.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

// MARK: - UITableViewDataSource
extension DetailsViewController: UITableViewDataSource {
    
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
        
        // Get user table view cell representable
        if let representable = self.viewModel.representableForRow(at: indexPath) as? DetailsTableViewCellRepresentable {
            
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: representable.cellReuseIdentifier, for: indexPath) as! DetailsTableViewCell
            
            // Setup cell
            cell.setup(with: representable)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension DetailsViewController: UITableViewDelegate {
 
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
        
//        // Get user
//        if let user = self.viewModel.didSelectRepresentable(at: indexPath) {
//
//
//        }
    }
}

