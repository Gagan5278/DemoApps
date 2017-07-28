//
//  TestServiceCall.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*-----------------------------------------------------Test Webservices ---------------------------------------------*/

import XCTest
import Accounts

@testable import TwitterDemo

class TestServiceCall: XCTestCase {
    
    var twitterViewController : TwitterViewController?
    var httpRequestObject : TwitterHttpRequest? = nil
    
    override func setUp() {
        super.setUp()
        self.httpRequestObject = TwitterHttpRequest.sharedInstance
        let storyBorad = UIStoryboard(name: "Main", bundle: nil)
        self.twitterViewController = storyBorad.instantiateViewController(withIdentifier: "TwitterViewController") as? TwitterViewController
        self.twitterViewController?.loadView()
        self.twitterViewController?.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
        self.httpRequestObject = nil
    }
    
    // Please perform real device Testing for below test cases
    func testUserHasAccountAccess()
    {
        let promise = expectation(description: "Get Twiter account object")
        var responseError : Error?
        var twitterAccount : ACAccount?
      //
        self.twitterViewController?.getTwitterAccountServicePermission(completionHandler: { (account, error) in
                responseError = error
                twitterAccount = account
                promise.fulfill()
        })
        waitForExpectations(timeout: 7, handler: nil)
        XCTAssertNil(responseError, "Error from server \(String(describing: responseError?.localizedDescription))")
        XCTAssertNotNil(twitterAccount, "no account access")
    }
    
    func testTimeLineWebServiceCall() {
        
        let promise = expectation(description: "Get Twiter account object")
        var responseError : Error?
        var twitterAccount : ACAccount?
        //
        self.twitterViewController?.getTwitterAccountServicePermission(completionHandler: { (account, error) in
            responseError = error
            twitterAccount = account
            promise.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError, "Error from server \(String(describing: responseError?.localizedDescription))")
        XCTAssertNotNil(twitterAccount, "no account access")
        
        //
        let promiseSerivce = expectation(description: "Staus code : 200")
        var responseServiceError : Error?
        var responseData : Data?
        let statusesShowEndpoint =  "https://api.twitter.com/1.1/statuses/home_timeline.json?count=50"
        
        self.httpRequestObject?.callServiceWithURL(urlFeedback: statusesShowEndpoint, withAccount: twitterAccount!, completionHandler:{ (data, error) in
            responseServiceError = error
            responseData = data
            promiseSerivce.fulfill()
        })
    
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNil(responseServiceError, "Error from server \(String(describing: responseError?.localizedDescription))")
        XCTAssertNotNil(responseData, "no data from server")
    }
    
}
