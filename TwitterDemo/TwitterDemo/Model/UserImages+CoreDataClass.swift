//
//  UserImages+CoreDataClass.swift
//
//
//  Created by  on 03/07/17.
//
//

import Foundation
import  UIKit
import CoreData

@objc(UserImages)
public class UserImages: NSManagedObject {
    
    //save image in coredata for offline access
    class func saveImage(image: UIImage, forIDString : String, inContext  context : NSManagedObjectContext)
    {
        if  let userImageObject = NSEntityDescription.insertNewObject(forEntityName: "UserImages", into: context) as? UserImages
        {
            userImageObject.urlString = forIDString
            let dataImage = UIImagePNGRepresentation(image)
            userImageObject.userImage = dataImage as NSData?
            do
            {
                try  context.save()
            }
            catch  {
                print("error in save :\(error.localizedDescription)")
            }
        }
    }
    
    //get image from coredata
   class func getImageForID(idString :String, inContext  context : NSManagedObjectContext) -> UIImage?
    {
        var userImage : UIImage?
        if let userObject = getObjectForID(strID: idString, inContext:context)
        {
            if let data =  userObject.userImage
            {
                userImage =  UIImage(data: data as Data)
            }
        }
        return userImage
    }
    
   class func getObjectForID(strID: String, inContext  context : NSManagedObjectContext) -> UserImages?
    {
        var userObject : UserImages?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"UserImages")
        fetchRequest.predicate = NSPredicate(format: "urlString==%@",strID)
        fetchRequest.fetchLimit = 1
        do
        {
            let arrayOfObject =  try context.fetch(fetchRequest)
            if arrayOfObject.count > 0
            {
                userObject = arrayOfObject.first as? UserImages
            }
        }
        catch let error as NSError
        {
            print("error is : \(error.localizedDescription)")
        }
        return userObject
    }
    
    //Delete opertion on Cell to remove User Tweet
    class func deleteImageForID(stringID : String, inContext conext : NSManagedObjectContext)
    {
        if let userObject = getObjectForID(strID: stringID, inContext: conext)
        {
            conext.delete(userObject)
            if conext.hasChanges {
                do {
                    try conext.save()
                } catch let nserror as NSError {
                    NSLog("some error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
        }
    }
}
