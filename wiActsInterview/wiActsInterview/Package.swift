//
//  Package.swift
//  wiActsInterview
//
//  Created by Richard Velazquez on 7/28/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit
import LocalAuthentication

class Package: NSObject {
    var randomString : String?
    var date : String?
    var currentTouchIDState : NSData?
    let stringLength = 15
    
    override init() {
        super.init()
        self.generateRandomString()
        self.saveStringToKeyChain()
        self.updateTouchIdData()
    }
    
    private func generateRandomString() {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<stringLength) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }

        self.randomString = randomString as String
    }
    
    private func saveStringToKeyChain() {
        let keyChainWrapper = KeychainWrapper()
        keyChainWrapper.mySetObject(self.randomString, forKey: kSecValueData)
    }
    
    private func updateTouchIdData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let savedState = defaults.valueForKey("touch") as? NSData {
            self.compareSavedStateToCurrentStateAndUpdateAccordingly(savedState)
        
        } else {
            self.currentTouchIDState = getCurrentStateContextState()
            self.date = "\(NSDate())"
            defaults.setValue(self.currentTouchIDState!, forKey: "touch")
            defaults.setValue(self.date!, forKey: "date")
        }
    }
    
    private func getCurrentStateContextState() -> NSData {
        let context = LAContext()
        context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: nil)
        
        if let domainState = context.evaluatedPolicyDomainState {
            return domainState
        } else {
            return NSData()
        }
    }
    
    
    private func compareSavedStateToCurrentStateAndUpdateAccordingly(savedUserTouchIDState: NSData) {
        let currentUserTouchIDState = self.getCurrentStateContextState()
        
        if currentUserTouchIDState == savedUserTouchIDState {
            self.currentTouchIDState = savedUserTouchIDState
            self.date = (NSUserDefaults.standardUserDefaults().valueForKey("date") as! String)
        } else {
            self.currentTouchIDState = currentUserTouchIDState
            self.date = "\(NSDate())"
            NSUserDefaults.standardUserDefaults().setValue(self.date, forKey: "date")
            NSUserDefaults.standardUserDefaults().setValue(self.currentTouchIDState, forKey: "touch")
        }
        
    }
    
    
}
