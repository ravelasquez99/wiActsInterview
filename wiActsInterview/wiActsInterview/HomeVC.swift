//
//  HomeVC.swift
//  wiActsInterview
//
//  Created by Richard Velazquez on 7/28/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedString = KeychainWrapper().myObjectForKey("v_Data") {
            //to show you it is saved properly
            print(savedString)
        }
    }
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        self.updateServer()
    }
    
    func updateServer() {
        self.sendServerInfo()
    }
    
    func sendServerInfo() {
        let package = Package()
        APIService.sendServerJSONWithPackage(package) { (result) in
            self.presentAlertWithString("Information Sent To Server")
        }
    }
    
    func presentAlertWithString(string : String) {
        let alertController = UIAlertController(title: string, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }
}