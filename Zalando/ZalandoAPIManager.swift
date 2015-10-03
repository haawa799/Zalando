//
//  ZalandoAPIManager.swift
//  Zalando
//
//  Created by Andriy K. on 10/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import AFNetworking

// MARK: - Constants
struct ApiManagerConstants {
  struct NotificationKey {
    static let NoApiKey = "NoApiKeyNotification"
  }
  struct URL {
    static let BaseURL = "https://www.wanikani.com/api"
  }
  struct NSUserDefaultsKeys {
    static let WaniKaniApiKey = "WaniAPIManagerKey"
  }
  struct ResponseKeys {
    static let UserInfoKey = "user_information"
    static let RequestedInfoKey = "requested_information"
  }
}

class ZalandoAPIManager: NSObject {
  
  // MARK: - Singltone
  
  var token: String {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).myToken
  }
  
  let hardcodedMe = "83001082258"
  
  static func sharedInstance() -> ZalandoAPIManager {
    return ZalandoAPIManager()
  }
  
  func authanticate(completion: ()->()) {
    
    let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://api.dz.zalan.do/auth/token"))
    manager.requestSerializer = AFHTTPRequestSerializer()
    manager.requestSerializer.setAuthorizationHeaderFieldWithUsername("haawaplus@gmail.com", password: "Googlie9")
    manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/x.zalando.myfeed+json") as Set<NSObject>
    manager.GET("https://api.dz.zalan.do/auth/token", parameters: nil, success: { (op, res) -> Void in
      //
//      print(res)
      
      if let dict = res as? NSDictionary {
        if let tok = dict["access_token"] as? String, let type = dict["access_type"] as? String {
          (UIApplication.sharedApplication().delegate as! AppDelegate).myToken = type + " " + tok
          completion()
        }
      }
      
      }) { (op, error) -> Void in
        completion()
    }
  }
  
  func feed(handler: (response: NSDictionary?) -> ()) {
    let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://api.dz.zalan.do/feeds/\(hardcodedMe)/items?limit=300&action=refresh"))
    manager.requestSerializer = AFHTTPRequestSerializer()
    manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
    manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/x.zalando.myfeed+json") as Set<NSObject>
    manager.GET("https://api.dz.zalan.do/feeds/\(hardcodedMe)/items?limit=300&action=refresh", parameters: nil, success: { (op, res) -> Void in
      //
      handler(response: res as? NSDictionary)

      
      
      }) { (op, error) -> Void in
        print(error)
        handler(response: nil)
    }
  }
  
  func tinder(handler: (response: NSDictionary?) -> ()) {
    
    let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://api.dz.zalan.do/customer-profiles/me/preferences/brand%3AQQQ"))
    manager.requestSerializer = AFJSONRequestSerializer()
    manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
    manager.requestSerializer.setValue("application/x.zalando.myfeed+json;version=2", forHTTPHeaderField: "Accept")
    manager.requestSerializer.setValue("application/x.zalando.myfeed+json;version=2", forHTTPHeaderField: "Content-Type")
    manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/x.zalando.myfeed+json;version=2") as Set<NSObject>
    
    let params = [
      "opinion" : "DISLIKE"
    ]
    
    manager.PUT("https://api.dz.zalan.do/customer-profiles/\(hardcodedMe)/preferences/brand%3AQQQ", parameters: params, success: { (op, res) -> Void in
      
      handler(response: res as? NSDictionary)
      
      }) { (op, error) -> Void in
        print(error)
        handler(response: nil)
    }
  }
  
}
