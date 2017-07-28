//
//  TableViewTest.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*----------------------------------------------TableView &  FetchResultController Test cases--------------------------------------------------------------------------*/
import XCTest
import CoreData

@testable import TwitterDemo

class TableViewTest: XCTestCase {
     var twitterViewController : TwitterViewController?
    
    var managedObjectContext: NSManagedObjectContext!

    
    override func setUp() {
        super.setUp()
        let storyBorad = UIStoryboard(name: "Main", bundle: nil)
        self.twitterViewController = storyBorad.instantiateViewController(withIdentifier: "TwitterViewController") as? TwitterViewController
        self.twitterViewController?.loadView()
    }
    
    override func tearDown() {
        self.twitterViewController  = nil
        super.tearDown()
    }
    
    //MARK: Test for view loaded
    func testViewDidLoad ()
    {
        XCTAssertNotNil( self.twitterViewController?.view, "View not initialised propoerly")
    }
    
    func testParentViewHasTableViewAsSubview()
    {
        let arrayOfView = self.twitterViewController?.view.subviews
        XCTAssertTrue((arrayOfView?.contains((self.twitterViewController?.timeLineTableView)!))!, "View does not contain table as a subview")
    }

    func testTableViewLoaded()
    {
        XCTAssertNotNil(self.twitterViewController?.timeLineTableView, "Table is  nil")
    }
    
    func testViewConfirmUITableViewDelegateProtocol()
    {
        XCTAssertTrue((self.twitterViewController?.conforms(to: UITableViewDelegate.self))!, "Does not confirm tableView Delegate")
    }
    
   func testTableViewIsConnectedToDelegate()
   {
            XCTAssertNotNil(self.twitterViewController?.timeLineTableView.delegate,"Table delegate cannot be nil")
    }
    
    func testViewConfirmTableViewDatasourceProtocol()
    {
        XCTAssertTrue((self.twitterViewController?.conforms(to: UITableViewDataSource.self))!, "Does not confirm tableview datasource")
    }
    
    func testTableViewHasDataSource()
    {
        
        XCTAssertNotNil(self.twitterViewController?.timeLineTableView.dataSource,"Table datasource cannot be nil")
    }
    
    //Number of section
    func testTableViewNumberOfSection()
    {
        let section = 1  //there is only one section in our case
        XCTAssertTrue(self.twitterViewController?.timeLineTableView.numberOfSections == section, "Number of section can not be zero or other value")
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
    
    //MARK:- Number of rows. Please test on Real device
    func testNumberOfRowsInSection()
    {
        do {
            try   self.twitterViewController?.fetchResultController?.performFetch()
        }
        catch
        {
            print("Error is \(error.localizedDescription)")
        }
             XCTAssertTrue(self.twitterViewController?.timeLineTableView.numberOfRows(inSection: 0) != 0, "Number of Rows can't be zero")
    }
    
    //Test custom cell
    func testCustomCell() {
        let customCell: CustomTableViewCell = self.twitterViewController?.timeLineTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CustomTableViewCell
        XCTAssertNotNil(customCell, "No Custom Cell Available")
    }
    
    //MARK:- FetchController
    
    func testFetchControllerIsNotNil()
    {
        XCTAssertNotNil(self.twitterViewController?.fetchResultController != nil, "FetchResultController can't be nil")
    }
    
    func testViewConfirmFetchControllerDelegate()
    {
         XCTAssertTrue((self.twitterViewController?.conforms(to: NSFetchedResultsControllerDelegate.self))!, "Does not confirm FetchController Delegate")
    }
  }
