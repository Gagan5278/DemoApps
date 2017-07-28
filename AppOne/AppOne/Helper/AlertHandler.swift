//
//  ViewController.swift
//  AppOne
//
//  Created by  on 01/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*--------- Class with a class function to show alert throughout the app at any viewController. Class function accept handler for user action  ---------*/

import UIKit

class AlertHandler: NSObject {
    
    class func showAlertWithTitle(title : String, message : String, handler : ((UIAlertAction) -> Void)?)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        if let lastViewController = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.last {
            lastViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
