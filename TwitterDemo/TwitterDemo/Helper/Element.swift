//
//  Element.swift
//  TwitterDemo
//
//  Created by on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*----- An struct to create dictionary object into  a Model 'Element'. Struct also convert date format & also implement 'Comparable' protocol for the data sorting-----*/

import Foundation

struct Element {
    let displayName: String
    let postedTime: Date
    let message: String
    let userID : String
    let screenName : String
    
    init?(dict:[String:String]) {
        let df = DateFormatter()
        df.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
        let timeText = dict[createdAtString]
        guard let date = df.date(from: timeText!) else {
            return nil
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss" 
        let outputDate = outputFormatter.string(from: date)
        //print("outputDate is :\(outputDate)")
        
        guard
            let displayName = dict[userNameString],
            let postedTime = outputFormatter.date(from: outputDate),
            let message = dict[messageString],
            let id = dict[idString],
            let scrName = dict[screenNameString]
            else { return nil }
        
        self.displayName = displayName
        self.postedTime = postedTime
        self.message = message
        self.userID = id
        self.screenName = scrName
    }
}

extension Element: Comparable {
    
    static func <(lhs: Element, rhs: Element) -> Bool {
        if lhs.displayName != rhs.displayName {
            return lhs.displayName < rhs.displayName
        }
        return lhs.postedTime > rhs.postedTime
    }
    
    static func ==(lhs: Element, rhs: Element) -> Bool {
        return lhs.displayName == rhs.displayName && lhs.postedTime < rhs.postedTime
    }
}
