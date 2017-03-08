//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositories(with completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func toggleStarStatus(for repo: GithubRepository, completion: @escaping (Bool) -> Void){
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: repo.fullName) { (starred) in
            if starred == true {
                GithubAPIClient.unstarRepository(named: repo.fullName, completion: {
                })
                completion(false)
            } else if starred == false {
                GithubAPIClient.starRepository(named: repo.fullName, completion: {
                })
                completion(true)
            }
        }
    }

}
