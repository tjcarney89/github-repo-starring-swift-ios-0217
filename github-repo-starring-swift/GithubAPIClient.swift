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
        let urlString = "https://api.github.com/repositories?client_id=\(ID)&client_secret=\(secret)"
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
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: @escaping (Bool) -> Void) {
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let url = URL(string: urlString)
        if let url = url {
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("token \(token)", forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            let dataTask = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let response = response {
                    do {
                        if let responseJSON = response as? HTTPURLResponse {
                            if responseJSON.statusCode == 204 {
                                completion(true)
                            } else if responseJSON.statusCode == 404 {
                                completion(false)
                            }

                            print(responseJSON.statusCode)
                        }
                    } catch {
                        
                    }
                }
            })
            dataTask.resume()
            
        }
    }
    
    class func starRepository(named: String, completion: @escaping () -> Void) {
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: named) { (starred) in
            if starred == false {
                let urlString = "https://api.github.com/user/starred/\(named)"
                let url = URL(string: urlString)
                if let url = url {
                    var urlRequest = URLRequest(url: url)
                    urlRequest.addValue("token \(token)", forHTTPHeaderField: "Authorization")
                    urlRequest.httpMethod = "PUT"
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: urlRequest)
                    dataTask.resume()
                }
            }
            completion()
            


            
        }
    }
    
    class func unstarRepository(named: String, completion: @escaping () -> Void) {
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: named) { (starred) in
            if starred == true {
                let urlString = "https://api.github.com/user/starred/\(named)"
                let url = URL(string: urlString)
                if let url = url {
                    var urlRequest = URLRequest(url: url)
                    urlRequest.addValue("token \(token)", forHTTPHeaderField: "Authorization")
                    urlRequest.httpMethod = "DELETE"
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: urlRequest)
                    dataTask.resume()
                }
            }
            completion()
            
            
            
            
        }
    }

    
    
}
