//
//  FavoriteRepositoriesCachingManager.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import Foundation
import Combine

/// Favorite Repositories Caching Manager
class FavoriteRepositoriesCachingManager {
    
    /// Repositories
    @Published private var repositories: [Repository]
    
    /// Shared
    static let shared: FavoriteRepositoriesCachingManager = FavoriteRepositoriesCachingManager()
    
    /// Queue, for managing data reading and writing
    private var queue: DispatchQueue = DispatchQueue(label: "FavoriteRepositoriesCachingManager", attributes: .concurrent)
    
    /**
     Initializer
     */
    init() {
        self.repositories = FavoriteRepositoriesCachingUtil.getRepositories()
    }
    
    // MARK: - Getters
    
    /**
     Get repositories
     - Returns: List of repositories
     */
    func getRepositories() -> [Repository] {
        
        // Repositories list
        var repositoriesList: [Repository] = []
        
        // Set currencies list using synced queue
        self.queue.sync {
            repositoriesList = self.repositories
        }
        
        return repositoriesList
    }
    
    // MARK: - Setters
    
    /**
     Add repository
     - Parameter repository: Repository
     */
    func addRepository(_ repository: Repository) {
        
        // Set repository using async queue
        self.queue.async {
            
            // Append repository
            self.repositories.append(repository)
            
            // Save repositories
            FavoriteRepositoriesCachingUtil.saveRepositories(repositories: self.repositories)
        }
    }
    
    /**
     Remove repository
     - Parameter repository: Repository
     */
    func removeRepository(_ repository: Repository) {
        
        // Remove repository using async queue
        self.queue.async {
            
            // Remove repository
            for (index, userRepository) in self.repositories.enumerated() where userRepository.id == repository.id {
                self.repositories.remove(at: index)
                break
            }
            
            // Save repositories
            FavoriteRepositoriesCachingUtil.saveRepositories(repositories: self.repositories)
        }
    }
    
    func monitorRepositoriesUpdates(completion: @escaping ([Repository]) -> Void) -> AnyCancellable {
        
        self.$repositories.sink { repositories in
            
            DispatchQueue.main.async {
                completion(repositories)
            }
        }
    }
    
    /**
     Reset
     */
    func reset() {
        FavoriteRepositoriesCachingUtil.reset()
    }
}
