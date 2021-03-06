//
//  APIService.swift
//  wiActsInterview
//
//  Created by Richard Velazquez on 7/28/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit
import AVFoundation

class APIService: NSObject {
    
    class func sendServerJSONWithPackage(package : Package, completion: (result: String)->Void) {
        let myUrl = NSURL(string: "http://requestb.in/xy76tbxy")
        let postString = "json={\"AESKey\":\"\(package.encryptedKey)\",\"AESDate\":\"\(package.encryptedDate)\"}"

        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            completion(result: "done")

            
        }
        task.resume()

    }

}
