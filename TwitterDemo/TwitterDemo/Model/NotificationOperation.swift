//
//  NotificationOperation.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/**-------------- A class to store object in Coredata using Notification concurrency approach. There are two way to achieve concurrency 1. Parent-Child 2. Notification.  Here we are using notification. --------------*/

import UIKit
import CoreData

class NotificationOperation: Operation {
    
    //Main managed object context
    let mainManagedObjectContext: NSManagedObjectContext
    //Private managed object context to save object
    var privateManagedObjectContextOnNotification: NSManagedObjectContext!
    //An object of elemets to intterate in main()
    var elementObjects : [Element]?
    
    init(managedObjectContext: NSManagedObjectContext, elements : [Element]) {
        self.mainManagedObjectContext = managedObjectContext
        self.elementObjects = elements
        super.init()
    }
    
    override func main() {
        //Add Observer for save opeartion in core data
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveNotificationOnPrivateQueue), name:NSNotification.Name.NSManagedObjectContextDidSave , object: nil)
        //Initialize privateContext. The operation's init method is run on the thread  which  is most likely the 'main thread'. So initialize privatecontext in main()
        self.privateManagedObjectContextOnNotification = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        //mainmanagedobject context & privatemanagedobject context has same persitentstorecoordinator
        self.privateManagedObjectContextOnNotification.persistentStoreCoordinator = self.mainManagedObjectContext.persistentStoreCoordinator
        self.privateManagedObjectContextOnNotification.undoManager = nil
        self.privateManagedObjectContextOnNotification .performAndWait { () -> Void in
            self.importData()
        }
    }
    
    //MARK:- Import Data from JSON File
    func importData ()
    {
        //counter used to save object in batch
        var counter = 0
        for element in self.elementObjects!
        {
            counter += 1
            _ = TwitterUser.importData(elementObject: element, context: self.privateManagedObjectContextOnNotification)
            if counter % saveBatchSize == 0
            {
                self.saveInBatch()
            }
        }
        self.saveInBatch()
    }
    
    //MARK:- Batch Saving in CoreData
    private func saveInBatch()
    {
        if self.privateManagedObjectContextOnNotification.hasChanges {
            do {
                try self.privateManagedObjectContextOnNotification.save()
            }
            catch let error as NSError
            {
                print("error is : \(error.localizedDescription)")
            }
        }
    }
    
    //MARK:- ManageObjectContext Save Notiofication on main context
    @objc private func didSaveNotificationOnPrivateQueue(notiofication : NSNotification)
    {
        self.mainManagedObjectContext.mergeChanges(fromContextDidSave: notiofication as Notification)
    }
}
