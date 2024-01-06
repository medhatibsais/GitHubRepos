//
//  Searchable.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 06/01/2024.
//

import Foundation

/// Searchable
protocol Searchable {
    
    /**
     Search
     - Parameter text: String
     - Returns: Bool, to indicate that the provided search text is exists in the user name string
     */
    func search(text: String) -> Bool
}
