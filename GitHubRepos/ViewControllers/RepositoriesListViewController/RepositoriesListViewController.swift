//
//  RepositoriesListViewController.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

/// Repositories List View Controller
class RepositoriesListViewController: BaseViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    @IBOutlet private(set) weak var tableView: UITableView!
    
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    
    private(set) var viewModel: RepositoriesListViewModel!
    
    private var calendar: Calendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar = Calendar(identifier: .gregorian)
        self.calendar.timeZone = .current
        
        self.title = "Repositories"
        
        self.viewModel = RepositoriesListViewModel()
        
        self.setupBarButtonItems()
        
        self.setupTableView()
        
        self.setupSearchBar()
        
        let date = self.calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        self.viewModel.updateSelectedDate(date: date)
        
        if NetworkingManager.shared.isNetworkReachable {
         
            self.showLoadingView(true)
            
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
    
    private func setupBarButtonItems() {
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(self.didClickRightBarButtonItem(_:)))
        
        rightBarButtonItem.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func didClickRightBarButtonItem(_ sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "Select period", message: "Choose the date creation for your presented information", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Before 1 day", style: .default, handler: { [weak self] _ in
            
            guard let self = self else { return }
            
            self.viewModel.reset()
            
            self.showLoadingView(true)
            
            let date = self.calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            
            self.viewModel.updateSelectedDate(date: date)
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            
            self.loadRepositories(for: date)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Before 1 week", style: .default, handler: { [weak self] _ in
            
            guard let self = self else { return }
            
            self.viewModel.reset()
            
            self.showLoadingView(true)
            
            let date = self.calendar.date(byAdding: .weekOfMonth, value: -1, to: Date()) ?? Date()
            
            self.viewModel.updateSelectedDate(date: date)
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            
            self.loadRepositories(for: date)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Before 1 month", style: .default, handler: { [weak self] _ in
            
            guard let self = self else { return }
            
            self.viewModel.reset()
            
            self.showLoadingView(true)
            
            let date = self.calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            
            self.viewModel.updateSelectedDate(date: date)
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            
            self.loadRepositories(for: date)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if #available(iOS 16.0, *) {
            actionSheet.popoverPresentationController?.sourceItem = sender
        } else {
            // Fallback on earlier versions
            actionSheet.popoverPresentationController?.barButtonItem = sender
        }
        
        self.present(actionSheet, animated: true)

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
    
    // MARK: - Notifications
    
    override func handleNotifications(_ notification: NSNotification) {
        
        if notification.name.rawValue == NetworkingManager.Notifications.connectionEstablished.rawValue {
            
            if self.viewModel.handleInternetConnectionBack() {
                self.loadRepositories(for: self.viewModel.selectedDate)
            }
        }
        else if notification.name.rawValue == NetworkingManager.Notifications.connectionLost.rawValue {
            
            if self.viewModel.handleNoInternetConnection() {
                self.tableView.reloadData()
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
