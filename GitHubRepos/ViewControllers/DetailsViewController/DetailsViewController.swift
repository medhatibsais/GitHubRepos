//
//  DetailsViewController.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

/// Details View Controller
class DetailsViewController: BaseViewController {
    
    /// Table view
    @IBOutlet private weak var tableView: UITableView!
    
    /// View model
    private(set) var viewModel: DetailsViewModel!
    
    /// Repository
    var repository: Repository!
    
    /// Index path
    var indexPath: IndexPath!
    
    /// delegate
    weak var delegate: DetailsViewControllerDelegate?
    
    /**
     Initializer
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Hide bottom bar when pushing the view
        self.hidesBottomBarWhenPushed = true
    }
    
    /**
     Initializer
     */
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Hide bottom bar when pushing the view
        self.hidesBottomBarWhenPushed = true
    }
    
    /**
     View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        self.title = self.repository.name
        
        // Init view model
        self.viewModel = DetailsViewModel(repository: self.repository)
        
        // Setup bar button items
        self.setupBarButtonItems()
        
        // Setup table view
        self.setupTableView()
    }
        
    /**
     Setup table view
     */
    private func setupTableView() {
        
        // Set table view separator style to none
        self.tableView.separatorStyle = .none
        
        // Set delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register cell
        DetailsTableViewCell.register(in: self.tableView)
    }
    
    /**
     Setup bar button items
     */
    private func setupBarButtonItems() {
        
        // Right bar button item
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: self.repository.isFavorite ? "star.fill" : "star"), style: .plain, target: self, action: #selector(self.didClickRightBarButtonItem))
        
        // Set right bar button item
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    /**
     Did click right bar button item
     */
    @objc private func didClickRightBarButtonItem() {
        
        // Toggle value
        self.repository.isFavorite.toggle()
        
        // Update right bar button item image
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: self.repository.isFavorite ? "star.fill" : "star")

        // Remove/Add repository
        self.repository.isFavorite ? FavoriteRepositoriesCachingManager.shared.addRepository(self.repository) : FavoriteRepositoriesCachingManager.shared.removeRepository(self.repository)
        
        // Call delegate
        self.delegate?.detailsViewController(didUpdateFavoriteStatusFor: self.repository, at: self.indexPath)
    }
}

/// Details View Controller Delegate
protocol DetailsViewControllerDelegate: NSObjectProtocol {
    
    /**
     Did update favorite status for
     - Parameter repository: Repository
     - Parameter indexPath: IndexPath
     */
    func detailsViewController(didUpdateFavoriteStatusFor repository: Repository, at indexPath: IndexPath)
}
