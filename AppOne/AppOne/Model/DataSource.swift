//
//  DataSource.swift
//  AppOne
//
//  Created by  on 01/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*--------- Data Source class fetch items from Document directory if user has modified items else create a new array of items ---------*/

import UIKit

class DataSource: NSObject {
    
    //Array to store Int items
    var arrayOfRecord : [Int]?
    
    class var sharedInstance : DataSource {
        struct Static {
            static let dataSourceInstance : DataSource = DataSource()
        }
        return Static.dataSourceInstance
    }
    
    override init() {
        super.init()
        var dataArray = [Int]()
        //Check if file exist. If Yes, then altered itmes are available in Document directory else fill array from 1...65535
        if FileManager.default.fileExists(atPath: getFullPathForSavedFile())
        {
            do {
                let filePath = getFullPathForSavedFile()
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as NSData) as? NSArray
                dataArray += array as! Array
            }
            catch
            {
                print("Error in getting file data is \(error.localizedDescription)")
            }
        }
        else{
            dataArray += 1...65535
        }
        self.arrayOfRecord = dataArray
    }
    
    //MARK:- Get item count in array
    func arrayCount() -> Int
    {
        return (self.arrayOfRecord?.count)!
    }
    
    //MARK:- Remove Item from Array
    func removeItemAtIndex(index : Int)
    {
        self.arrayOfRecord?.remove(at: index)
        self.saveArrayItemObject()
    }
    
    //MARK:- Path for file in document Directory
     func getFullPathForSavedFile() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(fileNameString)?.path
        return filePath!
    }
    
    //MARK:- Save aletred array in Directory
    private func saveArrayItemObject() {
        let pathOfFile = getFullPathForSavedFile()
        let data = NSKeyedArchiver.archivedData(withRootObject: self.arrayOfRecord!)
        do {
            try data.write(to: URL(fileURLWithPath: pathOfFile))
        } catch {
            print("Couldn't write file \(error.localizedDescription)")
        }
    }
}
