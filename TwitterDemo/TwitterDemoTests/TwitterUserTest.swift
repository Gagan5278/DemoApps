//
//  TwitterUserTest.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*---------------------------------------------- Test cases for CoreData operations-------------------------------------------*/

import XCTest
import CoreData
@testable import TwitterDemo

class TwitterUserTest: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext!
    var twitterViewController : TwitterViewController?

    override func setUp() {
        super.setUp()
        let coreDataStack = CoreDataStack()
        self.managedObjectContext = coreDataStack.context
        
        //
        let storyBorad = UIStoryboard(name: "Main", bundle: nil)
        self.twitterViewController = storyBorad.instantiateViewController(withIdentifier: "TwitterViewController") as? TwitterViewController
    }
    
    override func tearDown() {
        self.managedObjectContext = nil
        super.tearDown()
    }
    
    func testManagedObject()
    {
        XCTAssertNotNil(self.managedObjectContext, "self.managedObjectContext is nil")
    }
    
    func testAddUserInCoreData() {
     let dictionaryData = [userNameString : "Name", idString :"814554267823", createdAtString:"Fri Jun 30 05:39:03 +0000 2017",messageString:"This is for testing only",screenNameString:"testscreenanme"]
      let element = Element(dict: dictionaryData)
        //Add in core data
        let object =  TwitterUser.importData(elementObject: element, context: self.managedObjectContext!)
        XCTAssertNotNil(object, "Can Not insert object")
     }
    
    func testNotEntryForSameData()
    {
        let _ =  TwitterUser.importData(elementObject: addObjectCommon(), context: self.managedObjectContext!)
        let _ =  TwitterUser.importData(elementObject: addObjectCommon(), context: self.managedObjectContext!)
        
        let count =  TwitterUser.checkForObjectCountWithIdentifier(identifier: "8126782323443", inContext: self.managedObjectContext!)
        XCTAssertTrue(count == 1, "Duplicate object available")
    }
    
    func testGetUserFromCoreData()
    {
       let object =  TwitterUser.findOrCreateObjectIfNotExistInConext(context: self.managedObjectContext!, identfier: "81267823")
        XCTAssertNotNil(object, "Object does not exist in memory")
    }
    
    func testDeleteObjectFromCoreData()
    {
        let userToRemove =  TwitterUser.importData(elementObject: addObjectCommon(), context: self.managedObjectContext!)
        self.managedObjectContext?.delete(userToRemove!)
        let count =  TwitterUser.checkForObjectCountWithIdentifier(identifier: "8126782323443", inContext: self.managedObjectContext!)
        XCTAssertTrue(count == 0, "Can not delete object from coredata")
    }

    func addObjectCommon() -> Element
    {
        let idString = "8126782323443"
        let dictionaryData = [userNameString : "Name", "id" : idString, createdAtString:"Fri Jun 30 05:39:03 +0000 2017",messageString:"This is for testing only",screenNameString:"testscreenanme"]
        var arrayOfItems : [[String:String]] = []
        arrayOfItems.append(dictionaryData)
        let sortedElms = arrayOfItems.flatMap(Element.init).sorted()
        return sortedElms.first!
    }
    
    //User save Image test
    func testAddUserImageInDataBase()
    {
        let stringID = "32343"
        UserImages.saveImage(image: #imageLiteral(resourceName: "twittersquarelogo"), forIDString:stringID , inContext: self.managedObjectContext)
        let image = UserImages.getImageForID(idString: stringID, inContext: self.managedObjectContext)
        XCTAssertNotNil(image, "Image could not save in coredata")
    }
    
    func testDeleteUserImage()
    {
        let stringID = "32343"
        UserImages.saveImage(image: #imageLiteral(resourceName: "twittersquarelogo"), forIDString:stringID , inContext: self.managedObjectContext)
        UserImages.deleteImageForID(stringID: stringID, inContext: self.managedObjectContext)
        let image = UserImages.getImageForID(idString: stringID, inContext: self.managedObjectContext)
       XCTAssertNil(image, "Could not delete image")
    }
}
