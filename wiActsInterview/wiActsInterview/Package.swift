//
//  Package.swift
//  wiActsInterview
//
//  Created by Richard Velazquez on 7/28/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit
import LocalAuthentication
import CryptoSwift

class Package: NSObject {
    var key : String?
    var iv : String?
    var date : String?
    var encryptedKey : String?
    var encryptedDate : NSString?
    var currentTouchIDState : NSData?
    let stringLength = 16
    
    override init() {
        super.init()
        self.generateRandomStrings()
        self.savekeyToKeyChain()
        self.updateTouchIdData()
        self.generateEncryptedData()
    }
    
    private func generateRandomStrings() {
        self.key = generateRandomString()
        self.iv = generateRandomString()
    }
    
    private func generateRandomString()->String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<stringLength) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        
        return randomString as String
    }
    
    private func savekeyToKeyChain() {
        let keyChainWrapper = KeychainWrapper()
        keyChainWrapper.mySetObject(self.key, forKey: kSecValueData)
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
    
    private func getCurrentStateContextState() -> NSData {
        let context = LAContext()
        context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: nil)
        
        if let domainState = context.evaluatedPolicyDomainState {
            return domainState
        } else {
            return NSData()
        }
    }
    
    private func generateEncryptedData() {
        do {
            self.encryptedDate = try self.aesEncryptDataWithKey(self.key!, iv: self.iv!, dataToEncrypt: self.date!)
            self.encryptedKey = try self.aesEncryptDataWithKey(self.key!, iv: self.iv!, dataToEncrypt: self.key!)
            
        } catch {
            print("error")
        }
    }
    
    private func aesEncryptDataWithKey(key: String, iv: String, dataToEncrypt : String ) throws -> String{
        do {
            let aes = try AES(key: key, iv: iv)
            let ciphertext = try aes.encrypt(dataToEncrypt.utf8.map({$0}))
            return ciphertext.toHexString()
        } catch {
            print(error)
        }
        
        return "success"
    }
    
}
