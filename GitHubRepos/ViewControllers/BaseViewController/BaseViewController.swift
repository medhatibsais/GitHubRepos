//
//  BaseViewController.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

/// Base View Controller
class BaseViewController: UIViewController {
    
    /// Loading view
    var loadingView: UIView!
    
    /**
     View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup loading view
        self.setupLoadingView()
        
        // Setup navigation bar
        self.setupNavigationBar()
        
        // Register notifications
        self.registerNotifications()
    }
    
    /**
     Setup navigation bar
     */
    private func setupNavigationBar() {
        
        // Setup appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.blue.withAlphaComponent(0.8)]
        
        // Set appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    /**
     Setup loading view
     */
    private func setupLoadingView() {
        
        // Setup loading view
        self.loadingView = UIView()
        self.loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add loading view
        self.view.addSubview(self.loadingView)
        
        // Setup constraints
        self.loadingView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.loadingView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.loadingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // Setup loading indocator
        let loadingIdicator = UIActivityIndicatorView(style: .large)
        loadingIdicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIdicator.stopAnimating()
        loadingIdicator.color = .white
        
        // Add to view
        self.loadingView.addSubview(loadingIdicator)
        
        // Setup constraints
        loadingIdicator.centerYAnchor.constraint(equalTo: self.loadingView.centerYAnchor).isActive = true
        loadingIdicator.centerXAnchor.constraint(equalTo: self.loadingView.centerXAnchor).isActive = true
        
        // Hide the loading view initially
        self.loadingView.isHidden = true
    }
    
    /**
     Show loading view
     - Parameter show: Bool, boolean flag to know if we want to show it or hide it
     */
    func showLoadingView(_ show: Bool) {
        
        DispatchQueue.main.async {
         
            // Start/Stop loading indicator animation
            if let loadingIndicator = self.loadingView.subviews.first as? UIActivityIndicatorView {
                show ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
            }
            
            // Show/Hide loading view
            self.loadingView.isHidden = !show
            self.view.bringSubviewToFront(self.loadingView)
        }
    }
    
    func getTabBarController() -> UITabBarController? {
        return self.tabBarController
    }
    
    // MARK: - Notifications
    
    /**
     Register notifications
     */
    func registerNotifications() {
        
        // Observe notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotifications(_:)), name: NSNotification.Name(NetworkingManager.Notifications.connectionEstablished.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotifications(_:)), name: NSNotification.Name(NetworkingManager.Notifications.connectionLost.rawValue), object: nil)
    }
    
    /**
     Handle notifications
     - Parameter notification: NSNotification
     */
    @objc func handleNotifications(_ notification: NSNotification) {
        
        if notification.name.rawValue == NetworkingManager.Notifications.connectionLost.rawValue {
            
            SystemUtils.showMessageAlert(title: "Connection Lost", message: "Internet connection Lost")
        }
    }
}
