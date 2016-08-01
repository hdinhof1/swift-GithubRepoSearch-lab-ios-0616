//
//  GithubAPIClient.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        
        Alamofire.request(.GET, Secrets.git_url_hdinhof1_repos)
            .responseJSON { (response) in
                switch response.result {
                case .Success:
                    print("Got repositories ")
                    if let JSON = response.result.value as? NSArray {
                        completion(JSON)
                    }
                case .Failure(let error):
                    print("Something went wrong getting repos \(error)")
                }
        }
    }
    
    class func searchRepositoriesFor(searchTerm: String, completion:(JSON) -> ()) {
        
        Alamofire.request(.GET, "https://api.github.com/search/repositories?q=\(searchTerm)&order=asc")
        .responseJSON { (response) in
            switch response.result {
                
                case .Success:
                    print("Got repos in here!")
                    if let data = response.result.value {
                        let json = JSON(data)  //incomplete_results  items  total_count
                        completion(json)
                }
                case .Failure(let error):
                    print("Something went wrong getting repos \(error)")
            }
            
        }
    }
    
    
    class func checkIfRepositoryIsStarred(fullName: String, completion:(Bool) -> ()) {
        let url_search_string = "\(Secrets.git_url_user_starred)/\(fullName)"
        let authHeaders = ["Authorization": "\(Secrets.git_personal_access_token)"]
        
        Alamofire.request(.GET,
            url_search_string,
            parameters: nil,
            encoding: ParameterEncoding.JSON,
            headers: authHeaders).validate()
            .responseJSON { (response) in
                if let httpStatusCode = response.response?.statusCode {
                    switch httpStatusCode {
                    case 204:
                        completion(true)
                    case 404:
                        completion(false)
                    default:
                        print("Other status code \(httpStatusCode) with error \(response.result.error) ")
                    }
                }
        }
    }
    
    
    class func starRepository(fullName: String, completion: () -> ()) {
        let url_search_string = "\(Secrets.git_url_user_starred)/\(fullName)"
        let authHeaders = ["Authorization": "\(Secrets.git_personal_access_token)"]
        
        Alamofire.request(.PUT,
            url_search_string,
            parameters: nil,
            encoding: ParameterEncoding.JSON,
            headers: authHeaders).validate()
            .responseJSON { (response) in
                switch response.result {
                    
                case .Success:
                    print("Starred repo \(fullName.uppercaseString)")
                    completion()
                    
                case .Failure(let error):
                    print("Something went wrong starring repo \(error)")
                    completion()
                }
        }
    }
    
    
    class func unStarRepository(fullName: String, completion: () -> ()) {
        let url_search_string = "\(Secrets.git_url_user_starred)/\(fullName)"
        let authHeaders = ["Authorization": "\(Secrets.git_personal_access_token)"]
        
        Alamofire.request(.DELETE,
            url_search_string,
            parameters: nil,
            encoding: ParameterEncoding.JSON,
            headers: authHeaders).validate()
            .responseJSON { (response) in
                switch response.result {
                    
                case .Success:
                    print("You just unstarred \(fullName.uppercaseString)")
                    completion()
                    
                case .Failure(let error):
                    print("Couldn't unstar repo \(error) ")
                    completion()
                }
        }
    }
    
    
    
    
}
