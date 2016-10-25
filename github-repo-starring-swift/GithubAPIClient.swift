//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(githubAPIURL)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(_ fullName: String, completion: @escaping (Bool) -> ()) {
        let urlString = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(githubClientID)&client_secret=\(githubClientSecret)&access_token=\(githubAccessToken)"
        guard let url = URL(string: urlString) else { assertionFailure("Invalid URL"); return }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { assertionFailure("Unable to get response \(error?.localizedDescription)"); return }
            if httpResponse.statusCode == 204 {
                completion(true)
            }
            else if httpResponse.statusCode == 404 {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    class func starRepository(named repository: String, completion: @escaping () -> ()) {
        let urlString = "\(githubAPIURL)/user/starred/\(repository)?client_id=\(githubClientID)&client_secret=\(githubClientSecret)&access_token=\(githubAccessToken)"
        guard let url = URL(string: urlString) else { assertionFailure("Invalid URL"); return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            completion()
        }
        
        task.resume()
    }
    
    class func unstarRepository(named repository: String, completion: @escaping () -> ()) {
        let urlString = "\(githubAPIURL)/user/starred/\(repository)?client_id=\(githubClientID)&client_secret=\(githubClientSecret)&access_token=\(githubAccessToken)"
        guard let url = URL(string: urlString) else { assertionFailure("Invalid URL"); return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            completion()
        }
        
        task.resume()
    }
    
}

