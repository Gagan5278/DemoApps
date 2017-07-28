//
//  TouchAuthentication+FileTest.swift
//  AppOne
//
//  Created by on 01/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

import XCTest
import LocalAuthentication
@testable import AppOne

class TouchAuthentication_FileTest: XCTestCase {
    //TouchAuthenticationHandler Object
    var sharedInstanceTouch : TouchAuthenticationHelper? = nil
    //DataSource Object
    var dataSourceObject : DataSource?
    //ViewController Object
    var touchViewController : ViewController?
    override func setUp() {
        super.setUp()
        //Get touch instance
        self.sharedInstanceTouch = TouchAuthenticationHelper.sharedInstance
        //get DataSource instance
        self.dataSourceObject = DataSource.sharedInstance
        //Initialize ViewController
        self.touchViewController = ViewController(nibName: nil, bundle: nil)
        self.touchViewController?.viewDidLoad()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        self.sharedInstanceTouch  = nil
        self.dataSourceObject = nil
        self.touchViewController = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    //MARK:- Test touch is available or not. Please Test on Real Device for accurate result
    func testTouchAvailableOnDevice()
    {
        let error =  self.sharedInstanceTouch?.canAuthenticate()
        XCTAssertTrue((error?.code != LAError.Code.touchIDNotAvailable.rawValue ), "Touch Id not availble on your device")
    }
    
    func testFingurePrintNotAvailable()
    {
        let error =  self.sharedInstanceTouch?.canAuthenticate()
        XCTAssertTrue((error?.code != LAError.Code.touchIDNotEnrolled.rawValue ), "No Fingure Print enrolled in your device")
    }
    
    func testPasscodeNotSetInDevice() //passcodeNotSet
    {
        let error =  self.sharedInstanceTouch?.canAuthenticate()
        XCTAssertTrue((error?.code != LAError.Code.passcodeNotSet.rawValue ), "No passcode set in your device")
    }
    
    //File test in document directory
    func testFileExistInDocumentDirectory()
    {
        let filePath = self.dataSourceObject?.getFullPathForSavedFile()
       XCTAssertTrue(FileManager.default.fileExists(atPath:filePath!), "File either not created or some error has taken place in file creation")
    }
    
    func testArrayCountIsNotZero()
    {
        XCTAssertTrue(self.dataSourceObject?.arrayCount() != 0, "Array can't be empty")
    }
    
    func testItemIsGettingRemoveFromArray()
    {
       let preRemoveCount = self.dataSourceObject?.arrayCount()
        self.dataSourceObject?.removeItemAtIndex(index: 0)   //remove object at index '0'
        let postRemoveCount = self.dataSourceObject?.arrayCount()
        XCTAssertTrue((preRemoveCount! - postRemoveCount!) == 1 ,"Error in removing items from array")
    }
    
}
