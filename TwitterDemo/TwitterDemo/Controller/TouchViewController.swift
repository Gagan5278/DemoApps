//
//  TouchViewController.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*------ This is the RootViewController of the demo app. Controller provide user authentication steps. If Authenticated successfully then move to next screen i.e. TwitterViewController ------*/

//NOTE:- This view controller added only for detail explanation of TouchAuthentication. We can perform Touch opertaion on 'TwitterViewController' and get user permission. We have added this ViewController only for demo.

import UIKit
import LocalAuthentication

class TouchViewController: UIViewController {

    @IBOutlet weak var authenticationButton: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //set navigation Title
        self.title = "Auth"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  let nserror =   TouchAuthenticationHelper.sharedInstance.canAuthenticate()
        {
            var authErrorString = "Check your Touch ID Settings."
            switch (nserror.code) {
            case LAError.Code.touchIDNotEnrolled.rawValue:
                self.authenticationButton.isUserInteractionEnabled = true   //Enable state for user passscode entry
                authErrorString = "Tap to open via Passcode"
                break;
            case LAError.Code.touchIDNotAvailable.rawValue:
                authErrorString = "Tap to open via Passcode"
                self.authenticationButton.isUserInteractionEnabled = true   //Enable state for user passscode entry
                break;
            case LAError.Code.passcodeNotSet.rawValue:
                authErrorString = passcodeNotSetString
                break;
            default:
                authErrorString = checkIDSettingString
            }
            self.authenticationButton.setTitle(authErrorString, for: .normal)
        }
        else{
            self.authenticationButton.isUserInteractionEnabled = true   //Enable state as fingure print availbale
            self.authenticationButton.setTitle( "Touch to open app", for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Authentication button pressed button action
    @IBAction func authenticationButtonPressed(_ sender: Any) {
        TouchAuthenticationHelper.sharedInstance.authenticateWithSuccess({
            DispatchQueue.main.async {
                self.presentAlertControllerWithMessage("Successfully Authenticated!")
            }
        }, failure:{ errorCode in
            var authErrorString : String
            switch (errorCode) {
            case LAError.systemCancel.rawValue:
                authErrorString = systemCancelString
                break;
            case LAError.authenticationFailed.rawValue:
                authErrorString = authenticationFailedString
                break;
            case LAError.userCancel.rawValue:
                authErrorString = userCancelString
                break;
            case LAError.userFallback.rawValue:
                authErrorString = userFallbackString
                break;
            case LAError.touchIDNotEnrolled.rawValue:
                authErrorString = touchIDNotEnrolledString
                break;
            case LAError.touchIDNotAvailable.rawValue:
                authErrorString = touchIDNotAvailableString
                break;
            case LAError.passcodeNotSet.rawValue:
                authErrorString = passcodeNotSetString
                break;
            default:
                authErrorString = checkIDSettingString
                break;
            }
            self.presentAlertControllerWithMessage(authErrorString)
        })
    }
    
    // MARK: - Navigation Move to next screen if authenticated successfully.
    func authenticationSuccessHandler(action: UIAlertAction) {
        let twitterVC  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwitterViewController") as! TwitterViewController
        self.navigationController?.pushViewController(twitterVC, animated: true)
    }
    
    //MARK:- Show alert for user info
    func presentAlertControllerWithMessage(_ message : String) {
        if message == authSuccessString {
            AlertHandler.showAlertWithTitle(title: "Message", message: message as String, handler: self.authenticationSuccessHandler(action:))
        }
        else{
            AlertHandler.showAlertWithTitle(title: "Message", message: message as String, handler: nil)
        }
    }
}
