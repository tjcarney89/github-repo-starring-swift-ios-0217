//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositories {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
        
        
        
        
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = self.store.repositories[indexPath.row]
        self.store.toggleStarStatus(for: repo) { (starred) in
            if starred == false {
                let myAlert = UIAlertController(title: "Unstarred", message: "You just unstarred \(repo.fullName)", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in self.dismiss(animated: true, completion: nil) } )
                myAlert.addAction(myAction)
                self.present(myAlert, animated: true)
                myAlert.accessibilityLabel = "You just unstarred \(repo.fullName)"
                print("You just unstarred that repo")
            } else if starred == true {
                let myAlert = UIAlertController(title: "Starred", message: "You just starred \(repo.fullName)", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in self.dismiss(animated: true, completion: nil) } )
                myAlert.addAction(myAction)
                self.present(myAlert, animated: true)
                myAlert.accessibilityLabel = "You just starred \(repo.fullName)"
                print("You just starred that repo")
            }
        }
    }

}
