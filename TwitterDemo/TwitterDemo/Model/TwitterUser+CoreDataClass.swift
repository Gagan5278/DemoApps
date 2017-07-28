//
//  TwitterUser+CoreDataProperties.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*----  Class to import object in Coredata on privateContext. Class first check for the object in database. If object exist then return otherwise insert new object in database.----*/

import Foundation
import CoreData

@objc(TwitterUser)

public class TwitterUser: NSManagedObject {
    //MARK:-  Import element object  in coredata.
    class func importData(elementObject : Element?,  context : NSManagedObjectContext) -> TwitterUser?
    {
        if  let idString = elementObject?.userID {
            let dataEntityObject = self.findOrCreateObjectIfNotExistInConext(context: context, identfier: idString)
            dataEntityObject?.id = idString
            dataEntityObject?.created_at = elementObject?.postedTime as NSDate?
            dataEntityObject?.name = elementObject?.displayName
            dataEntityObject?.text = elementObject?.message
            dataEntityObject?.screen_name = elementObject?.screenName
            return dataEntityObject
        }
        return nil
    }
    
    //MARK:- Check if object already exist in coredata. if 'yes' then return stored object else call to create a new object and return object
    class  func findOrCreateObjectIfNotExistInConext(context : NSManagedObjectContext , identfier identifier : String  ) -> TwitterUser?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:self.entityName())
        fetchRequest.predicate = NSPredicate(format: "id==%@",identifier)
        fetchRequest.fetchLimit = 1
        do
        {
            let arrayOfObject =  try context.fetch(fetchRequest)
            if arrayOfObject.isEmpty == false
            {
                return (arrayOfObject.first as! TwitterUser)  //Object found & return
            }
            else
            {
                return  insertNewObjectInContext(context: context)  // call to instert a new object in database
            }
        }
        catch let error as NSError
        {
            print("error is : \(error.localizedDescription)")
        }
        return nil
    }
    
    //MARK:- resturns the entity name
    class func entityName() -> String
    {
        return self.description()
    }
    
    //MARK:- Insert a new object in database & return inserted object
    class func insertNewObjectInContext(context : NSManagedObjectContext)->TwitterUser?
    {
        return (NSEntityDescription.insertNewObject(forEntityName: self.entityName(), into: context) as! TwitterUser)
    }
    
    //MARK:- check for object count with identifier
    class func checkForObjectCountWithIdentifier(identifier : String, inContext context : NSManagedObjectContext  ) -> Int
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:self.entityName())
        fetchRequest.predicate = NSPredicate(format: "id==%@",identifier)
        do
        {
            let arrayOfObject =  try context.fetch(fetchRequest)
           return arrayOfObject.count
        }
        catch let error as NSError
        {
            print("error is : \(error.localizedDescription)")
        }
        return 0
    }
}

