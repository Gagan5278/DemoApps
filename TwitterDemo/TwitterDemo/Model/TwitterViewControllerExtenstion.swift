//
//  TwitterViewController.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/**-------TwitterViewController Exntesion for all type of data opertaion like TableView DataSource, Dalegates and fetchResultController delegates.-------**/

import Foundation
import  UIKit
import CoreData


//MARK:- Extension TableView's DataSource
extension TwitterViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        self.prepareCell(cell: customCell, indexPath: indexPath as NSIndexPath)
        return customCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController?.sections {
            let sectoinsInfo = sections[section]
            return sectoinsInfo.numberOfObjects
        }
        return 0
    }
}

//MARK:-TwitterViewController Extension TableView's delegate
extension TwitterViewController : UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let userToRemove = self.fetchResultController?.object(at: indexPath) as! TwitterUser
            //Store For other opertaion on server & image delete
                if (editingStyle == UITableViewCellEditingStyle.delete) {
                    self.mainContextObject.delete(userToRemove)
                    if self.mainContextObject.hasChanges {
                        do {
                            try self.mainContextObject.save()
                        } catch let nserror as NSError {
                            NSLog("some error \(nserror), \(nserror.userInfo)")
                            abort()
                        }
                    }
                }
        }
    }
}

//MARK:- TwitterViewController Extesnion for NSFetchedResultsControllerDelegate
extension TwitterViewController : NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.timeLineTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.timeLineTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch (type)
        {
        case .insert:
            self.timeLineTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            self.timeLineTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default :
            print("None")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type)
        {
        case .insert:
            self.timeLineTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.timeLineTableView.deleteRows(at: [indexPath!], with: .fade)
        case .move: break
        case . update : break
        }
    }
}
