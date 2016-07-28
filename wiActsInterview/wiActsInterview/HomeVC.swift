//
//  HomeVC.swift
//  wiActsInterview
//
//  Created by Richard Velazquez on 7/28/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var sendServerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedString = KeychainWrapper().myObjectForKey("v_Data") {
            print(savedString)
        }
        self.setupActivityIndicator(activityIndicator)
    }
    
    func setupActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
    }
    
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        activityIndicator.startAnimating()
        sendServerButton.userInteractionEnabled = false
        self.updateServer()
    }
    
    func updateServer() {
        self.sendServerInfo { (result) in
            
            self.activityIndicator.stopAnimating()
            self.sendServerButton.userInteractionEnabled = true
            
            if result == "success" {
                self.presentAlertWithString("Message Sent To Server")
            } else {
                self.presentAlertWithString("Something Went Wrong")
            }
        }
    }
    
    func sendServerInfo(completion: (result : String)-> Void) {
        let package = Package()
        APIService.sendServerJSONWithPackage(package)
        print(package.randomString!)
        completion(result: "success")
    }
    
    func presentAlertWithString(string : String) {
        let alertController = UIAlertController(title: string, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }
}