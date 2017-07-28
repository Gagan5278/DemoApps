//
//  TouchAuthenticationHelper.swift
//  AppOne
//
//  Created by  on 01/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*-----------------------------  A class that handles user authentication process. -------------------------- */

import UIKit
import LocalAuthentication

typealias EHFCompletionBlock = (Void) ->()
typealias EHFAuthenticationErrorBlock = (Int) -> ()

class TouchAuthenticationHelper: NSObject {
    
    fileprivate var context : LAContext
    
    // reason string presented to the user in auth dialog
    var reason : NSString
    
    // Default value is LAPolicyDeviceOwnerAuthenticationWithBiometrics.  This value will be useful if LocalAuthentication.framework introduces new auth policies in future version of iOS.
    var policy : LAPolicy
    
    class var sharedInstance : TouchAuthenticationHelper {
        struct Static {
            static let instance : TouchAuthenticationHelper = TouchAuthenticationHelper()
        }
        return Static.instance
    }
    
    override init(){
        self.context = LAContext()
        self.policy = .deviceOwnerAuthenticationWithBiometrics
        self.reason = "AppOne"
    }
    
    //MARK:- Check for status in device for authentication
    func canAuthenticate() -> NSError?
    {
        var error:NSError?
        if self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            print("error is : \(String(describing: error))")
        }
        return error
    }
    
    func authenticateWithSuccess(_ success: @escaping EHFCompletionBlock, failure: @escaping EHFAuthenticationErrorBlock){
        self.context = LAContext()
        var authError : NSError?
        if (self.context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError)) {
            self.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason:
                reason as String, reply:{ authenticated, error in
                    if (authenticated) {
                        DispatchQueue.main.async(execute: {success()})
                    } else {
                        DispatchQueue.main.async(execute: {failure(error!._code)})
                    }
            })
        } else {
            failure(authError!.code)
        }
    }
}
