//
//  TouchViewTest.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

import XCTest
import  LocalAuthentication
@testable import TwitterDemo
class TouchViewTest: XCTestCase {
    var sharedTouchInstance : TouchAuthenticationHelper?
    //TouchViewController instance
    var touchViewController : TouchViewController?

    override func setUp() {
        super.setUp()
        //Initialize ViewController
        let storyBorad = UIStoryboard(name: "Main", bundle: nil)
        self.touchViewController = storyBorad.instantiateViewController(withIdentifier: "TouchViewController") as? TouchViewController
        self.touchViewController?.loadView()
        //
       self.sharedTouchInstance = TouchAuthenticationHelper.sharedInstance
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.touchViewController = nil
        self.sharedTouchInstance = nil
        super.tearDown()
    }
    
    //MARK: Test for view loaded
    func testViewHasLoaded ()
    {
        XCTAssertNotNil( self.touchViewController?.view, "View can't Initialize")
    }
    
    //Test view has button i.e. AUthentication button
    func testAuhtheniticationButtonAddedOnView()
    {
        let arrayOfView = self.touchViewController?.view.subviews
        XCTAssertTrue((arrayOfView?.contains((self.touchViewController?.authenticationButton)!))!, "View does not contain authenticationButton as a subview")
    }
    
    
//MARK:- Test touch is available or not
     func testTouchAvailableOnDevice()
    {
       let error =  sharedTouchInstance?.canAuthenticate()
        XCTAssertTrue((error?.code != LAError.Code.touchIDNotAvailable.rawValue ), "Touch Id not availble on your device")
    }
    
    func testPasscodeNotSetInDevice() //passcodeNotSet
    {
        let error =  self.sharedTouchInstance?.canAuthenticate()
        XCTAssertTrue((error?.code != LAError.Code.passcodeNotSet.rawValue ), "No passcode set in your device")
    }
    
    func testFingurePrintNotAvailable()
    {
        let error =  self.sharedTouchInstance?.canAuthenticate()
        XCTAssertTrue((error?.code != LAError.Code.touchIDNotEnrolled.rawValue ), "No Fingure Print enrolled in your device")
    }
    
}
