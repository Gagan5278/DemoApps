//
//  CoreDataStack.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*--------------- Create a persiatenttorecontainer in memory for Test cases------*/

import Foundation
import  CoreData

public final class CoreDataStack {
    public init() {
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "TwitterDemo")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.configuration = "Default"
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
