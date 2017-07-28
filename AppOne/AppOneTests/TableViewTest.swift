//
//  TableViewTest.swift
//  AppOne
//
//  Created by  on 01/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/* -----------------------------------------------------------Test Cases for TableView-----------------------------------------------*/
import XCTest
@testable import AppOne

class TableViewTest: XCTestCase {
    //Instance for TableViewController
        var recordTableController : TableViewController?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.recordTableController = TableViewController(style: .plain)
        self.recordTableController?.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
         self.recordTableController = nil
        super.tearDown()
    }
    
    //MARK: Test for view loaded
    func testViewDidLoad ()
    {
        XCTAssertNotNil( self.recordTableController?.view, "View not initialised")
    }
    
    //Test Table loaded
    func testTableViewLoaded()
    {
        XCTAssertNotNil(self.recordTableController?.tableView, "Table not loaded")
    }
    
    //Tests for tableView protocol & delegates
    func testViewConfirmUITableViewDelegateProtocol()
    {
        XCTAssertTrue((self.recordTableController?.conforms(to: UITableViewDelegate.self))!, "Does not confirm tableView Delegate")
    }
    
    func testTableViewIsConnectedToDelegate()
    {
        XCTAssertNotNil(self.recordTableController?.tableView.delegate,"Table delegate cannot be nil")
    }
    
    func testViewConfirmTableViewDatasourceProtocol()
    {
        XCTAssertTrue((self.recordTableController?.conforms(to: UITableViewDataSource.self))!, "Does not confirm tableview datasource")
    }
    
    func testTableViewHasDataSource()
    {
        XCTAssertNotNil(self.recordTableController?.tableView.dataSource,"Table datasource cannot be nil")
    }
    
    //Test custom cell
    func testCustomCell() {
        self.recordTableController?.tableView.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.indentifier())
        let customCell: CustomTableCell =  self.recordTableController?.tableView.dequeueReusableCell(withIdentifier: CustomTableCell.indentifier()) as! CustomTableCell
        XCTAssertNotNil(customCell, "No Custom Cell Available")
    }
    
    //TableView number os sections test
    func testTableViewNumberOfSection()
    {
        let section = 1  //there is only one section in our case
        XCTAssertTrue(self.recordTableController?.tableView.numberOfSections == section, "Number of section can not be zero or other value")
    }

    //Number of rows test
    func testTableViewNumberOfRowsInSection()
    {
        let rowsCount = 0   // we can test in vice versa i.e. cell has 'SomeInt' items
        XCTAssertTrue(self.recordTableController?.tableView.numberOfRows(inSection: 0) != rowsCount, "Number of rows can not be zero")
    }
}
