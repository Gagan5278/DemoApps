//
//  UserImages+CoreDataProperties.swift
//  
//
//  Created by on 03/07/17.
//
//

import Foundation
import CoreData


extension UserImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserImages> {
        return NSFetchRequest<UserImages>(entityName: "UserImages")
    }

    @NSManaged public var urlString: String?
    @NSManaged public var userImage: NSData?

}
