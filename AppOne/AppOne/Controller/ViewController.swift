//
//  ViewController.swift
//  AppOne
//
//  Created by  on 01/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/**--------RootViewController of the app. Provide access to the app usinng Local Authentication------**/

//NOTE:- This view controller added only for detail explanation of TouchAuthentication. We can perform Touch opertaion on 'TwitterViewController' and get user permission. We have added this ViewController only for demo.

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    //Authentication button for infomtion display & user action as well
    var authenticationButton = UIButton(type: .custom)
    
 //MARK:- View Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //Add restoration idendetifier as we wokring on Code level UI 
        self.restorationIdentifier = "ViewController"
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //navugation Title
        self.title = "Auth"  //Set as per screen description requirement
        //Set restoration identifier
        self.view.restorationIdentifier = "ViewControllerViewIdentifier"
        //set button in view
        self.authenticationButton.addTarget(self, action: #selector(authenticate(_:)), for: .touchUpInside)
        self.authenticationButton.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(self.authenticationButton)
        self.authenticationButton.frame = CGRect(x: 0.0, y: 0.0, width: 300.0, height: 150.0)
        self.authenticationButton.isEnabled = false   //Make user enable state false initially
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  let nserror =   TouchAuthenticationHelper.sharedInstance.canAuthenticate()
        {
            var authErrorString = "Check your Touch ID Settings."
            switch (nserror.code) {
            case LAError.Code.touchIDNotEnrolled.rawValue:
                self.authenticationButton.isEnabled = true   //Enable state for user passscode entry
                authErrorString = "Tap to open via Passcode"
                break;
            case LAError.Code.touchIDNotAvailable.rawValue:
                self.authenticationButton.isEnabled = true //Enable state for user passscode entry when device does not have touch ID
                authErrorString = "Tap to open via Passcode"
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
            self.authenticationButton.isEnabled = true   //Enable state as fingure print availbale
            self.authenticationButton.setTitle( "Touch to open app", for: .normal)
        }
        self.authenticationButton.translatesAutoresizingMaskIntoConstraints = false
        self.authenticationButton.centerInSuperView()
    }
    
    //MARK:- Authentication button Tap Action
   @objc private func authenticate(_ sender: UIButton) {
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
    
// MARK: - Navigation
   private func authenticationSuccessHandler(action: UIAlertAction) {
      let dataViewControllerObject = TableViewController(style: .plain)
      self.navigationController?.pushViewController(dataViewControllerObject, animated: true)
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

//MARK:- Restoration Delegate
extension ViewController : UIViewControllerRestoration
{
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        let viewControllerObject = ViewController(nibName: nil, bundle: nil)
        return viewControllerObject
    }
}

//MARK:- App Restoration delegates
extension ViewController
{
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
}
