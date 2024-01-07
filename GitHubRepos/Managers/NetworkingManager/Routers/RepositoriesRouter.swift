//
//  RepositoriesRouter.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import Alamofire

/// Repositories Router
enum RepositoriesRouter: URLRequestConvertible {
    
    /// Search
    case search(parameters: Parameters)
    
    /// Method
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    /// Path
    var path: String {
        switch self {
        case .search:
            return "/search/repositories"
        }
    }
    
    /// Base URL String
    var baseURLString: String {
        return "https://api.github.com"
    }
    
    /**
     URL Request
     */
    func asURLRequest() throws -> URLRequest {
        
        // URL
        let url = try self.baseURLString.asURL()
        
        // Setup URL request
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.path))
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = ["Accept": "application/json"]
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        // Encode the requests with its own parameters
        switch self {
        case .search(let parameters):
            
            // Encode
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
