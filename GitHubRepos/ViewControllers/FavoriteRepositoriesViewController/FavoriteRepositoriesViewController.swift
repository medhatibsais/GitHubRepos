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
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    @IBOutlet private(set) weak var tableView: UITableView!
    
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    private(set) var viewModel: FavoriteRepositoriesViewModel!
    
    var favoriteRepositoriesListener: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favorites"
        
        self.viewModel = FavoriteRepositoriesViewModel()
        
        self.setupTableView()
        
        self.setupSearchBar()
        
        self.showLoadingView(true)
        
        self.favoriteRepositoriesListener = FavoriteRepositoriesCachingManager.shared.monitorRepositoriesUpdates(completion: { [weak self] repositories in
            
            guard let self = self else { return }
            
            self.viewModel.setData(repositories: repositories)
            
            self.tableView.reloadData()
            
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
    
    
    deinit {
        self.favoriteRepositoriesListener?.cancel()
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
//        self.searchBar.barTintColor = .black
//        self.searchBar.searchTextField.backgroundColor = .black
        self.searchBar.searchTextField.textColor = .white
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("usersListViewController.searchBar.placeholder", comment: ""), attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        
        if let searchImageView = self.searchBar.searchTextField.leftView as? UIImageView {
            searchImageView.tintColor = UIColor.white.withAlphaComponent(0.7)
        }
        
        // Set delegate
        self.searchBar.delegate = self
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
