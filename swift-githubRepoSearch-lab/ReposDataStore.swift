//
//  ReposDataStore.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                
                self.repositories.append(repository)
            }
            completion()
        }
    }
    
    func toggleStarStatusForRepository(repository: GithubRepository, completion:(Bool) -> ()) {
        GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName) { (starred) in
            if starred {
                GithubAPIClient.unStarRepository(repository.fullName, completion: {
                    print("unstarring repo")
                    completion(false)
                })
                
            } else {
                GithubAPIClient.starRepository(repository.fullName, completion: {
                    print("starring repo")
                    completion(true)
                })
            }
        }
        
    }
    // Seaches repos with searchTerm and initializes self.repositories
    func searchAndGetGithubReposForTerm(searchTerm: String, completion:() -> ()) {
        GithubAPIClient.searchRepositoriesFor(searchTerm) { (json) in
            self.repositories.removeAll()
            if let searchRepoArray = json["items"].array {
                for item in searchRepoArray {
                    let jsonRepo = item.dictionaryValue
                    let repository = GithubRepository(dictionary: jsonRepo)
                    
                    self.repositories.append(repository)
                }
                completion()
            }
        }
    }
}