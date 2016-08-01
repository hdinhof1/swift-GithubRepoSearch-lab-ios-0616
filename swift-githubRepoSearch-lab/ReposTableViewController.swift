//
//  ReposTableViewController.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.tableView.reloadData()
            })
        }
        
        
    }
    @IBAction func searchButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Search Repos", message: "Enter repo to search", preferredStyle: UIAlertControllerStyle(rawValue: 1)!)
        
        alertController.addTextFieldWithConfigurationHandler { (searchField) in
            //"Search term" is the grey placeholder text
            searchField.placeholder = NSLocalizedString("Search term", comment: "Search")
        }
        // how blocks used to be done! (for ObjC syntax review)
        //        addTextFieldWithConfigurationHandler:^(UITextField *textField)
        //            {
        //            textField.placeholder = NSLocalizedString(@"LoginPlaceholder", @"Login");
        //            }];
        
        let okAction = UIAlertAction(title: NSLocalizedString("Search", comment: "Search action"), style: UIAlertActionStyle(rawValue: 0)!) {[weak weakSelf = self] (action)  in
            print("Search tapped")
            let searchWord = alertController.textFields?.first
            if let searchWord = searchWord?.text {
                weakSelf!.store.searchAndGetGithubReposForTerm(searchWord, completion: {
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.tableView.reloadData()
                    })
                })
            }
            
        }
        alertController.addAction(okAction)
        
        
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRepo = store.repositories[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        store.toggleStarStatusForRepository(selectedRepo) { (nowStarred) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if nowStarred {
                    cell.detailTextLabel?.text = "★"
                    
                }else {
                    cell.detailTextLabel?.text = ""
                }
                cell.textLabel?.text = selectedRepo.fullName
            })
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = ""
        
        return cell
    }
    
}