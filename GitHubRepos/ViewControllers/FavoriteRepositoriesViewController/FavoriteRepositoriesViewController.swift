//
//  FavoriteRepositoriesViewController.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import UIKit
import Combine

/// Favorite Repositories View Controller
class FavoriteRepositoriesViewController: BaseViewController {
    
    /// Search bar
    @IBOutlet private weak var searchBar: UISearchBar!
    
    /// Table view
    @IBOutlet private(set) weak var tableView: UITableView!
    
    /// Table view bottom constraint
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    /// View model
    private(set) var viewModel: FavoriteRepositoriesViewModel!
    
    /// Favorite repositories listener
    private var favoriteRepositoriesListener: AnyCancellable?
    
    /**
     View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        self.title = NSLocalizedString("favoriteRepositoriesViewController.title", comment: "")
        
        // Init view model
        self.viewModel = FavoriteRepositoriesViewModel()
        
        // Setup table view
        self.setupTableView()
        
        // Setup search bar
        self.setupSearchBar()
        
        // Show loading view
        self.showLoadingView(true)
        
        // Setup listener
        self.favoriteRepositoriesListener = FavoriteRepositoriesCachingManager.shared.monitorRepositoriesUpdates(completion: { [weak self] repositories in
            
            // self
            guard let self = self else { return }
            
            // Set data
            self.viewModel.setData(repositories: repositories)
            
            // Reload table view
            self.tableView.reloadData()
            
            // Hide loading view
            self.showLoadingView(false)
        })
    }
    
    /**
     View will appear
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Register for keyboard notifications
        self.registerForKeyboardNotifications()
    }
    
    /**
     View will disappear
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unregister for keyboard notifications
        self.unregisterForKeyboardNotifications()
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
        
        // Register cells
        RepositoryTableViewCell.register(in: self.tableView)
        LoadingTableViewCell.register(in: self.tableView)
        EmptyTableViewCell.register(in: self.tableView)
    }
    
    /**
     Setup search bar
     */
    private func setupSearchBar() {
        
        // Setup search bar
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("favoriteRepositoriesViewController.searchBar.placeholder", comment: ""), attributes: [.foregroundColor: UIColor.gray.withAlphaComponent(0.7)])
        
        // Set delegate
        self.searchBar.delegate = self
    }
    
    /**
     Deinit
     */
    deinit {
        
        // Cancel listener subscription
        self.favoriteRepositoriesListener?.cancel()
    }
    
    // MARK: - Keyboard Notifications
    
    /**
     Register this view controller to receive keyboard notifications
     */
    private func registerForKeyboardNotifications() {
        
        // Add observers to detect when the keyboard opens and closed
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /**
     Unregister this view controller for keyboard notifications
     */
    private func unregisterForKeyboardNotifications(){
        
        // Remove the observers on keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /**
     Keyboard will show
     - Parameter notification: The notification object
     */
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard let info = notification.userInfo , let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue , let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // Get keyboard frame
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        // Get Space between safe area and superview
        let spaceBetweenSafeAreaAndSuperView: CGFloat = self.view.safeAreaInsets.bottom
        
        // Update constraints
        self.tableViewBottomConstraint.constant = (keyboardFrame.size.height - spaceBetweenSafeAreaAndSuperView)
        
        // Animate change in height
        UIView.animate(withDuration: duration, animations: { [weak self] () -> Void in
            self?.view.layoutIfNeeded()
        })
    }
    
    /**
     Keyboard will hide
     - Parameter notification: The notification object
     */
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        guard let info = notification.userInfo , let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // Update constraints
        self.tableViewBottomConstraint.constant = 0
        
        // Animate change in height
        UIView.animate(withDuration: duration, animations: { [weak self] () -> Void in
            self?.view.layoutIfNeeded()
        })
    }
}
