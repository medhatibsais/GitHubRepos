//
//  FavoriteRepositoriesCachingUtil.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import Foundation

/// Favorite Repositories Caching Util
class FavoriteRepositoriesCachingUtil {
    
    /// Keys
    enum Keys: String, CaseIterable {
        case favoriteRepositories   = "favorite_repositories"
    }
    
    /// User default standard object
    static private let userDefault = UserDefaults.standard
    
    /**
     Save Repositories
     - Parameter repositories: List of repositories
     */
    class func saveRepositories(repositories: [Repository]) {
        
        // Encode and save the data
        if let data = try? JSONEncoder().encode(repositories) {
            self.userDefault.set(data, forKey: Keys.favoriteRepositories.rawValue)
            
            // Synchronize
            self.userDefault.synchronize()
        }
    }
    
    /**
     Get Repositories
     - Returns: List of Repositories
     */
    class func getRepositories() -> [Repository] {
        
        // Repositories list
        var repositoriesList: [Repository] = []
        
        // Get data, and decode it to list of repositories
        if let data = self.userDefault.value(forKey: Keys.favoriteRepositories.rawValue) as? Data, let repositories = try? JSONDecoder().decode([Repository].self, from: data) {
            
            // Set the list
            repositoriesList = repositories
        }
        
        return repositoriesList
    }
    
    /**
     Reset
     */
    class func reset() {
        
        // Iterate over each user default's keys and remove it
        for key in Self.Keys.allCases {
            self.userDefault.removeObject(forKey: key.rawValue)
        }
        
        // Synchronize
        self.userDefault.synchronize()
    }
}
