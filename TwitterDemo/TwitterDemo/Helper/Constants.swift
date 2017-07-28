//
//  TwitterHttpRequest.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/******----- File stores all the constant used in the app -----*******/

import Foundation

//Core data atribute names
let createdAtString = "created_at"
let messageString = "text"
let idString = "id"
let userNameString = "name"
let screenNameString = "screen_name"

//Save batch size  constant. This constant used to store object in batches in coredata. We can set it to any integer value based on import data size
let saveBatchSize = 500


//Constant used in Touch authentication process
let systemCancelString = "System canceled auth request due to app coming to foreground or background."
let authenticationFailedString = "User failed after a few attempts."
let userCancelString = "User cancelled."
let userFallbackString = "Fallback auth method should be implemented here."
let touchIDNotEnrolledString = "No Touch ID fingers enrolled."
let touchIDNotAvailableString = "Touch ID not available on your device."
let passcodeNotSetString = "Need a passcode set to use Touch ID."
let checkIDSettingString = "Check your Touch ID Settings."
let authSuccessString  = "Successfully Authenticated!"


//SinceID for Twitter
let sinceIDString = "sinceIDTwitter"
