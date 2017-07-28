//
//  TwitterHttpRequest.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

import UIKit
import Accounts
import Social

class TwitterHttpRequest: NSObject {
    //Create Singlton Instance
    static let sharedInstance = TwitterHttpRequest()
    var strID : String?
    
    //Call WS for getting user timeline from Twitter
    func getFeedbackListFromService(urlString : String, account : ACAccount, completion : @escaping ([Element]?, Bool)-> Void)
    {
        callServiceWithURL(urlFeedback: urlString, withAccount: account) {[weak self] (data, error) in
            print("error is :\(String(describing: error))")
            if data != nil{
                do
                {
                    if let arrarOfRecords =   try  JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Array<Dictionary<String, AnyObject>>
                    {
                        if  arrarOfRecords.first != nil {
                            if  let dictData = arrarOfRecords.first
                            {
                                if  let sinceID = dictData["id"]
                                {
                                    UserDefaults.standard.set(sinceID, forKey: sinceIDString )
                                    UserDefaults.standard.synchronize()
                                }
                            }
                        }
                        if let arrayItems =  self?.createArrayOfDictionaryItems(arrayOfItems: arrarOfRecords)
                        {
                            let sortedElms = arrayItems.flatMap(Element.init).sorted()
                            completion(sortedElms, true)
                        }
                    }
                }
                catch
                {
                    print("Error in json :\(error.localizedDescription)")
                    completion(nil, false)
                }
            }
            else{
                completion(nil, false)
            }
        }
    }
    
    
    func callServiceWithURL(urlFeedback : String, withAccount : ACAccount, completionHandler : @escaping (Data?, Error?) -> Void)
    {
        
        let url = URL(string: urlFeedback)
        guard let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil) else {
            return
        }
        request.account = withAccount
        request.perform { (responseData, response, error) -> Void in
            if error != nil {
                print(error ?? "error in performing request :[")
            } else if responseData == nil {
                    let error = NSError(domain: "No Data found error", code: 0, userInfo: nil) as Error
                    completionHandler(nil,error)
            }
            else{
//                 let result = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
//                  print("result is :\(result)")
                completionHandler(responseData,nil)

            }
        }
    }
    
    //MARK:- Create data in proper format to show user
    func createArrayOfDictionaryItems(arrayOfItems : Array<Dictionary<String,AnyObject>>) ->  Array<[String:String]>? {
        var arrayOfModifiedItems : [[String:String]] = []
        for dictData in arrayOfItems
        {
            // print("dictData is :\(dictData)")
            var dictionaryTemp = [String : String]()
            var nameUser : String? = nil
            var screenName : String? = nil
            
            if let  userDict = dictData["user"] as? Dictionary<String, AnyObject>
            {
                if let name = userDict["name"]
                {
                    nameUser = name as? String
                }
                if let scrName = userDict["screen_name"]
                {
                    screenName = scrName as? String
                }
                if let id_str = userDict["id_str"]
                {
                    strID = id_str as? String
                }
            }
            if let createdTime = dictData["created_at"], let message = dictData["text"], let nextUserID = dictData["id"], let name = nameUser, let scrName = screenName
            {
                dictionaryTemp[createdAtString] = (createdTime as? String)?.lowercased()
                dictionaryTemp[messageString] = (message as? String)?.lowercased()
                dictionaryTemp[idString] = String(describing: nextUserID).lowercased()
                dictionaryTemp[userNameString] = name.lowercased()
                dictionaryTemp[screenNameString] = scrName
            }
            //Add items in array
            if  dictionaryTemp.isEmpty == false
            {
                arrayOfModifiedItems.append(dictionaryTemp)
            }
        }
        return arrayOfModifiedItems
    }
    
    //MARK:- Delete tweet from timeline. You can delete your authorised status not others
    //    func callDeleteServiceWithID(idString : String,completionHandler : @escaping (Data?, Error?) -> Void)
    //    {
    //        //create client object with userid
    //        let client = TWTRAPIClient(userID: Twitter.sharedInstance().sessionStore.session()?.userID)
    //        let id  = idString
    //        let deleteUrl = "https://api.twitter.com/1.1/statuses/destroy/\(id).json"
    //        var clientError : NSError?
    //        let request = client.urlRequest(withMethod: "POST", url: deleteUrl , parameters: nil, error: &clientError)
    //        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
    //            if connectionError != nil {
    //                print("Error: \(String(describing: connectionError))")
    //                completionHandler(nil, connectionError)
    //            }
    //            if let httpResponse = response as? HTTPURLResponse
    //            {
    //                print("Status code is : \(httpResponse.statusCode)")
    //                completionHandler(data, nil)
    //            }
    //        }
    //    }
}


