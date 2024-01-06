//
//  SystemUtils.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import UIKit

/// System Utils
class SystemUtils {
    
    /**
     Response JSON serializer
     - Parameter data: Data
     - Returns: Dictionary of Any type
     */
    class func responseJSONSerializer(data: Data) -> Any {
        
        // Serialize JSON object
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) else {
            return [:]
        }
        
        // Return the object
        return jsonObject
    }
    
    /**
     Show message alert
     - Parameter title: String
     - Parameter message: String
     */
    class func showMessageAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
         
            // Alert controller
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Add action
            alert.addAction(UIAlertAction(title: NSLocalizedString("alerts.actions.ok.title", comment: ""), style: .default))
            
            // Get the active window scene
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
              return
            }
            
            // Get root view controller
            let viewController = sceneDelegate.window?.rootViewController
            
            // Present on the root view controller
            viewController?.present(alert, animated: true)
        }
    }
}
