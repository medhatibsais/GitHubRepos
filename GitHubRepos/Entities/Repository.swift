//
//  Repository.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import Foundation

struct Repository: Codable {
    
    var id: Int
    var owner: User
    
    var name: String
    
    var description: String
    
    var starsRate: Int
    
    var creationDate: Date
    
    var forksCount: Int
    
    var htmlURL: String
    
    var language: String
    
    var isFavorite: Bool
    
    init() {
        self.owner = User()
        self.name = ""
        self.description = "Hey!, this is a new repository"
        self.starsRate = 0
        self.id = 0
        self.creationDate = Date()
        self.forksCount = 0
        self.htmlURL = ""
        self.language = ""
        self.isFavorite = false
    }
    
    init(representation: NSDictionary) {
        self.init()
        
        if let value = representation.value(forKey: CodingKeys.id.rawValue) as? Int {
            self.id = value
        }
        
        if let value = representation.value(forKey: CodingKeys.owner.rawValue) as? NSDictionary {
            self.owner = User(representation: value)
        }

        
        if let value = representation.value(forKey: CodingKeys.name.rawValue) as? String {
            self.name = value
        }

        
        if let value = representation.value(forKey: CodingKeys.description.rawValue) as? String {
            self.description = value
        }
        
        
        if let value = representation.value(forKey: CodingKeys.starsRate.rawValue) as? Int {
            self.starsRate = value
        }
        
        if let value = representation.value(forKey: CodingKeys.forksCount.rawValue) as? Int {
            self.forksCount = value
        }
        
        if let value = representation.value(forKey: CodingKeys.language.rawValue) as? String {
            self.language = value
        }
        
        if let value = representation.value(forKey: CodingKeys.htmlURL.rawValue) as? String {
            self.htmlURL = value
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let value = representation.value(forKey: CodingKeys.creationDate.rawValue) as? String, let date = dateFormatter.date(from: value) {
            self.creationDate = date
        }
        
        self.isFavorite = FavoriteRepositoriesCachingManager.shared.getRepositories().contains(where: { $0.id == self.id })
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case isFavorite
        case creationDate   = "created_at"
        case forksCount     = "forks"
        case htmlURL        = "html_url"
        case owner          = "owner"
        case starsRate      = "stargazers_count"
    }
    
    enum Order: String {
        case descending     = "desc"
        case ascending      = "asc"
    }
    
    enum Sort: String {
        case stars
    }
}
