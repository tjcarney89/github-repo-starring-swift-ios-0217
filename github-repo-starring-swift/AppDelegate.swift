//
//  AppDelegate.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import OHHTTPStubs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var starred: Bool!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if isRunningTests() == true {
            starred = true
            
            //stubbing GET repositories
            OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
                return(request.url?.host == "api.github.com" && request.url?.path == "/repositories")
                
            }) { (request) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(fileAtPath: OHPathForFileInBundle("repositories.json", Bundle(for: type(of: self)))!, statusCode: 200, headers: ["Content-Type" : "application/json"])
            }
            
            //stubbing GET star status
            OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
                return(request.url?.host == "api.github.com" && request.url?.path == "/user/starred/wycats/merb-core")
                
            }) { (request) -> OHHTTPStubsResponse in
                if self.starred == true {
                    return OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: nil)
                }
                else {
                    return OHHTTPStubsResponse(fileAtPath: OHPathForFileInBundle("not_starred.json", Bundle(for: type(of: self)))!, statusCode: 404, headers: ["Content-Type" : "application/json"])
                }
                
            }
            
            //stubbing PUT/DELETE star
            OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
                let urlCheck = (request.url?.host == "api.github.com" && request.url?.path == "/user/starred/wycats/merb-core")
                let httpMethodCheck = (request.httpMethod == "PUT" || request.httpMethod == "DELETE")
                return urlCheck && httpMethodCheck
                
            }) { (request) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: nil)
            }
        }
        
        return true
    }
    
    func isRunningTests() -> Bool {
        let env = ProcessInfo.processInfo.environment
        if let injectBundle = env["XCTestConfigurationFilePath"] {
            return NSString(string: injectBundle).pathExtension == "xctestconfiguration"
        }
        return false
    }

}

