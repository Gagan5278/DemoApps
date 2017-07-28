//
//  TableViewController.swift
//  AppOne
//
//  Created by  on 01/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/**----Second ViewController in main NavigationController. A subclass of UITableViewController. Display records  in cell with fade animation, cell delete & state preseravation--**/


import UIKit

class TableViewController: UITableViewController {
    
//MARK:- View Life Cycle
    override init(style: UITableViewStyle) {
        super.init(style: .plain)
        self.restorationIdentifier = "MyTableView"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Navigation title
        self.title = "Items"
        //set table restoration identifier
        self.tableView.restorationIdentifier = "TableView"
        //Register Table Cell with 'CustomTableCell'
        self.tableView.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.indentifier())
        //set cell height
        self.tableView.rowHeight = 80
        DispatchQueue.main.async {
           self.tableView.scrollToRow(at: IndexPath(row: UserDefaults.standard.integer(forKey: "cellRowId"), section: 0), at: .top, animated: false)
        }
        
        //Add Notification while app moves in background
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appMovedToBackground()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Call when app moves in background state
    func appMovedToBackground() {
        if let cell =  self.tableView.visibleCells.first as? CustomTableCell {
            let indexPath =   self.tableView.indexPath(for: cell)
            UserDefaults.standard.set((indexPath?.row)!+1, forKey: "cellRowId")  //save indexpath row for 
            UserDefaults.standard.synchronize()
        }
    }
}

//MARK:- App Restoration delegates
 extension TableViewController
 {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
 }

//MARK-: TableView Delegate
extension TableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            DataSource.sharedInstance.removeItemAtIndex(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //Reload Table here for cell adjustment & devide by 12 opertaion
            tableView.reloadData()
        }
    }
}

//MARK-: TableView DataSource
extension TableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.sharedInstance.arrayCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.indentifier(), for: indexPath)
        let itemVal = DataSource.sharedInstance.arrayOfRecord![indexPath.row]
        cell.textLabel?.text = "Item is : \(String(describing: itemVal))"
        cell.selectionStyle = .none
        //If value in array in divisible by 12 then make cell background color as green
       if itemVal % 12 == 0
       {
          cell.backgroundColor = UIColor.green
        }
        return cell
    }
}

//MARK:- Restoration Delegate
extension TableViewController : UIViewControllerRestoration
{
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        let viewControllerObject = TableViewController(style: .plain)
        return viewControllerObject
    }
}

//MARK:- ScrollView Delegate
extension TableViewController
{
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if  let array = self.tableView.indexPathsForVisibleRows
        {
            //Device visible cells into two parts
            let lowerSplit: ArraySlice<IndexPath> = array[0 ..< array.count / 2]
            let upperSplit: ArraySlice<IndexPath> = array[array.count / 2 ..< array.count]
        
            // make arrays from ArraySlice
            let lowerDeck: [IndexPath] = Array(lowerSplit)
            let upperDeck: [IndexPath] = Array(upperSplit)

            //Itterate lower deck i.e. View upper part
            for indexPath in lowerDeck
            {
                let itemVal = DataSource.sharedInstance.arrayOfRecord![indexPath.row]
                if    let topCell = self.tableView.cellForRow(at: indexPath)
                {
                    if itemVal % 12 != 0  //Check cell is not divisible by 12
                    {
                        let point = self.tableView.convert(topCell.center, to: self.tableView.superview)
                        let cellAlpha = ((point.y * 100) / CGFloat(lowerDeck.count*80)) / 100
                        let per = abs(100.0 - abs(CGFloat(1.0 - cellAlpha)*100))
                        topCell.backgroundColor = UIColor.red.adjustColor(by: per)
                    }
                }
            }
            //Itterate lower deck i.e. View Lower part
            for   indexPath in upperDeck
            {
                let itemVal = DataSource.sharedInstance.arrayOfRecord![indexPath.row]
                if let bottomCell = self.tableView.cellForRow(at: indexPath)
                {
                    if itemVal % 12 != 0  //Check cell is not divisible by 12
                    {
                        let point = self.tableView.convert(bottomCell.center, to: self.tableView.superview)
                        let cellAlpha = ((point.y * 100) / CGFloat(upperDeck.count*80)) / 100
                        let per = abs(100.0 - abs((0.8 - cellAlpha)*100))
                        bottomCell.backgroundColor = UIColor.blue.adjustColor(by: per)
                    }
                }
            }
        }
    }
}
