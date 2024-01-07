//
//  RepositoriesListViewController.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

/// Repositories List View Controller
class RepositoriesListViewController: BaseViewController {
    
    /// Search bar
    @IBOutlet private weak var searchBar: UISearchBar!
    
    /// Search bar top constraint
    @IBOutlet private(set) weak var searchBarTopConstraint: NSLayoutConstraint!
    
    /// Table view
    @IBOutlet private(set) weak var tableView: UITableView!
    
    /// Table view bottom constraint
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    /// View model
    private(set) var viewModel: RepositoriesListViewModel!
    
    /// Refresh control
    private(set) var refreshControl: UIRefreshControl!
    
    /// Calendar
    private var calendar: Calendar!
    
    /**
     View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup calendar
        self.calendar = Calendar(identifier: .gregorian)
        self.calendar.timeZone = .current
        
        // Se title
        self.title = NSLocalizedString("repositoriesListViewController.title", comment: "")
        
        // Init view model
        self.viewModel = RepositoriesListViewModel()
        
        // Setup bar button items
        self.setupBarButtonItems()
        
        // Setup table view
        self.setupTableView()
        
        // Setup search bar
        self.setupSearchBar()
        
        // Date
        let date = self.calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        // Update selected date
        self.viewModel.updateSelectedDate(date: date)
        
        // Check if internet is reachable
        if NetworkingManager.shared.isNetworkReachable {
         
            // Show loading view
            self.showLoadingView(true)
            
            // Load repositories
            self.loadRepositories(for: date)
        }
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
     Setup bar button items
     */
    private func setupBarButtonItems() {
        
        // Create bar button item
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(self.didClickRightBarButtonItem(_:)))
        
        // Disable button initially
        rightBarButtonItem.isEnabled = false
        
        // Set right bar button item
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    /**
     Did click right bar button item
     - Parameter sender: UIBarButtonItem
     */
    @objc private func didClickRightBarButtonItem(_ sender: UIBarButtonItem) {
        
        /**
         Load repositories
         - Parameter component: Calendar component
         - Parameter value: Int
         */
        func loadRepositories(with component: Calendar.Component, value: Int) {
            
            // Reset view model
            self.viewModel.reset()
            
            // Disable right bar button item
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            // Show loading view
            self.showLoadingView(true)
            
            // Date
            let date = self.calendar.date(byAdding: component, value: value, to: Date()) ?? Date()
            
            // Update selected date
            self.viewModel.updateSelectedDate(date: date)
            
            // Scroll to top
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            
            // Load repositories
            self.loadRepositories(for: date)
        }
        
        // Action sheet
        let actionSheet = UIAlertController(title: NSLocalizedString("repositoriesListViewController.actionSheet.title", comment: ""), message: NSLocalizedString("repositoriesListViewController.actionSheet.message", comment: ""), preferredStyle: .actionSheet)
        
        // Add action
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("repositoriesListViewController.actionSheet.1Day.action.title", comment: ""), style: .default, handler: { _ in
            
            // Load repositories
            loadRepositories(with: .day, value: -1)
        }))
        
        // Add action
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("repositoriesListViewController.actionSheet.1Week.action.title", comment: ""), style: .default, handler: { _ in
            
            // Load repositories
            loadRepositories(with: .weekOfMonth, value: -1)
        }))
        
        // Add action
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("repositoriesListViewController.actionSheet.1Month.action.title", comment: ""), style: .default, handler: { _ in
            
            // Load repositories
            loadRepositories(with: .month, value: -1)
        }))
        
        // Add action
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("repositoriesListViewController.actionSheet.cancel.action.title", comment: ""), style: .cancel))
        
        // Set popover item
        if #available(iOS 16.0, *) {
            actionSheet.popoverPresentationController?.sourceItem = sender
        } else {
            actionSheet.popoverPresentationController?.barButtonItem = sender
        }
        
        // Present
        self.present(actionSheet, animated: true)
    }
    
    /**
     Setup table view
     */
    private func setupTableView() {
        
        // Setup refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(self.willRefreshTableView), for: .valueChanged)
        
        // Set table view separator style to none
        self.tableView.separatorStyle = .none
        
        // Set refresh control
        self.tableView.refreshControl = self.refreshControl
        
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
        
        // Hide search bar initially
        self.searchBarTopConstraint.constant = -self.searchBar.frame.height
        
        // Setup search bar
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("repositoriesListViewController.searchBar.placeholder", comment: ""), attributes: [.foregroundColor: UIColor.gray.withAlphaComponent(0.7)])
        
        // Set delegate
        self.searchBar.delegate = self
    }
    
    /**
     Will refresh table view
     */
    @objc private func willRefreshTableView() {
        
        // Check if data is not loading
        guard !self.viewModel.isDataLoading, NetworkingManager.shared.isNetworkReachable else {
            
            // End refreshing if the network is lost
            if !NetworkingManager.shared.isNetworkReachable {
                self.refreshControl.endRefreshing()
            }
            
            return
        }
        
        // Reset view model
        self.viewModel.reset()
        
        // Disable right bar button item
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Load repositories
        self.loadRepositories(for: self.viewModel.selectedDate)
    }
    
    /**
     Reload table view data
     */
    func reloadTableViewData() {
        
        DispatchQueue.main.async {
         
            // Reload table view
            self.tableView.reloadData()
            
            // End refreshing
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Notifications
    
    /**
     Handle notifications
     - Parameter notification: NSNotification
     */
    override func handleNotifications(_ notification: NSNotification) {
        
        // Check if name is connection established
        if notification.name.rawValue == NetworkingManager.Notifications.connectionEstablished.rawValue {
            
            // Handle internet connection back
            if self.viewModel.handleInternetConnectionBack() {
                
                // Load repositories
                self.loadRepositories(for: self.viewModel.selectedDate)
            }
        }
        
        // Check if name is connection lost
        else if notification.name.rawValue == NetworkingManager.Notifications.connectionLost.rawValue {
            
            // Handle no internet connection
            if self.viewModel.handleNoInternetConnection() {
                
                // Reload table view data
                self.reloadTableViewData()
            }
            else {
                super.handleNotifications(notification)
            }
        }
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
