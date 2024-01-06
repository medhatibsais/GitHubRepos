//
//  DetailsViewController.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit

/// Details View Controller
class DetailsViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private(set) var viewModel: DetailsViewModel!
    
    var repository: Repository!
    
    var indexPath: IndexPath!
    
    weak var delegate: DetailsViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.repository.name
        
        self.viewModel = DetailsViewModel(repository: self.repository)
        
        self.setupBarButtonItems()
        self.setupTableView()
    }

    
    private func setupTableView() {
        
        // Set table view separator style to none
        self.tableView.separatorStyle = .none
        
        // Set delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        DetailsTableViewCell.register(in: self.tableView)
    }
    
    private func setupBarButtonItems() {
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: self.repository.isFavorite ? "star.fill" : "star"), style: .plain, target: self, action: #selector(self.didClickRightBarButtonItem))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func didClickRightBarButtonItem() {
        
        self.repository.isFavorite.toggle()
        
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: self.repository.isFavorite ? "star.fill" : "star")

        self.repository.isFavorite ? FavoriteRepositoriesCachingManager.shared.addRepository(self.repository) : FavoriteRepositoriesCachingManager.shared.removeRepository(self.repository)
        
        self.delegate?.detailsViewController(didUpdateFavoriteStatusFor: self.repository, at: self.indexPath)
    }
}

/// Details View Controller Delegate
protocol DetailsViewControllerDelegate: NSObjectProtocol {
    
    func detailsViewController(didUpdateFavoriteStatusFor repository: Repository, at indexPath: IndexPath)
}
