//
//  RepositoriesModel.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import Foundation
import Alamofire

/// Repositories Model
class RepositoriesModel {
    
    /// Request Tags
    enum RequestTags: String {
        case query          = "q"
        case itemsPerPage   = "per_page"
        case page
        case sort
        case order
    }
    
    /// Response Tags
    enum ResponseTags: String {
        case items
    }
    
    static let maximumItemsPerPage: Int = 30
    
    class func search(date: Date, order: Repository.Order, sortBy: Repository.Sort, pageNumber: Int, completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = .current
        
        var parameters = Parameters()
        parameters[RequestTags.order.rawValue] = order.rawValue
        parameters[RequestTags.sort.rawValue] = sortBy.rawValue
        parameters[RequestTags.itemsPerPage.rawValue] = self.maximumItemsPerPage
        parameters[RequestTags.page.rawValue] = pageNumber
        parameters[RequestTags.query.rawValue] = dateFormatter.string(from: date)
        
        Session.default.request(RepositoriesRouter.search(parameters: parameters)).response { response in
            
            switch response.result {
            case .success(let data):
                
                // Get data
                if let data = data {
                    
                    // Repositories
                    var repositories: [Repository] = []
                    
                    // json object
                    let jsonObject = SystemUtils.responseJSONSerializer(data: data)
                    
                    // Serialize object
                    if let jsonObject = jsonObject as? NSDictionary, let items = jsonObject.value(forKey: ResponseTags.items.rawValue) as? [NSDictionary] {
                        
                        // Iterate over each json object
                        for value in items {
                            
                            // Append to currencies list
                            repositories.append(Repository(representation: value))
                        }
                        
                        // Call completion
                        completion(.success(repositories))
                    }
                    else {
                        
                        // Call completion
                        completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                    }
                }
                else {
                    
                    // Create error
                    let error = AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.inputDataNilOrZeroLength)
                    
                    // Call completion
                    completion(.failure(error))
                }
                
            case .failure(let error):
                
                // Call completion
                completion(.failure(error))
            }
            
        }
        
    }
}
