//
//  TwitterViewController.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

//https://dev.twitter.com/twitterkit/ios/access-rest-api

/*--- Second View COntroller of the app shows Twitter Time line for logged in User. Timeline gets refreshed after every 2 minutes. All the records saved in coredata for offline access---*/

import UIKit
import  CoreData
import Accounts

//Table cell identifier
let cellIdentifier = "cellIdentifier"

class TwitterViewController: UIViewController {
    
    //TableView object
    @IBOutlet weak var timeLineTableView: UITableView!
    //URLSession configured with 'Default' to download user image from Twitter
    var urlSession : URLSession?
    //Shared instance for TwitterHttpRequest
    let httpRequestSharedManager = TwitterHttpRequest.sharedInstance
    //Fetch Result Controller
   var fetchResultController : NSFetchedResultsController<NSFetchRequestResult>?
    //array to store all items froom user timeline
    let importOperationQueue = OperationQueue.main
    
    //managedObjectCOntext instance
    let mainContextObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var accountStore: ACAccountStore = ACAccountStore()
    //Twitter Account Instance
    var twitterAccount: ACAccount?
    //Initial fetch count from twitter
    let tweetFetchCount = 50

    
    //Timer for background service call after every 120 seconds
    var timerPolling : Timer?
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Navigation Title
        self.title = "Twitter"
        //initialise session with default configuration
        self.urlSession = URLSession(configuration: .default)
        
        //set tableview row height
        self.timeLineTableView.estimatedRowHeight = 85.0
        self.timeLineTableView.rowHeight = UITableViewAutomaticDimension
  
        //Initialise fetch controller
        self.initializeFetchResultController()
        //perform Fetch Request
        do
        {
            try self.fetchResultController?.performFetch()
            print("Success")
            DispatchQueue.main.async {
                if (self.fetchResultController?.fetchedObjects?.count)! > 0
                {
                    self.timeLineTableView.scrollToRow(at: IndexPath(row: UserDefaults.standard.integer(forKey: "cellRowId"), section: 0), at: .top, animated: false)
                }
            }
        }
        catch let error as NSError
        {
            print("error is : \(error.localizedDescription)")
        }
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        //Get account access permission from user
        self.getTwitterAccountServicePermission {[weak self] (account, error) in
         if account != nil
         {
           self?.updateTimeLine()
         }
         else{
            //Remove polling timer as user don't allow to access twitter account
            self?.timerPolling?.invalidate()
            }

        }
        
    //Update Time line after every 120 seconds.
        self.timerPolling = Timer.scheduledTimer(timeInterval: 100, target: self, selector: #selector(updateTimeLine), userInfo: nil, repeats: true)
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
    
    //App moves in background by user
    func appMovedToBackground() {
        if let cell =  self.timeLineTableView.visibleCells.first as? CustomTableViewCell {
            let indexPath =   self.timeLineTableView.indexPath(for: cell)
            UserDefaults.standard.set((indexPath?.row)!+1, forKey: "cellRowId")
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- Get Twitter Access permission from User..
    func getTwitterAccountServicePermission( completionHandler : @escaping (ACAccount?, Error?) -> Void){
        let accountType: ACAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (granted: Bool, error: Error?) -> Void in
            if error != nil  {
                print("error! \(String(describing: error))")
                AlertHandler.showAlertWithTitle(title: "Message", message: (error?.localizedDescription)!, handler: nil)
                completionHandler(nil, error)
            }
            if granted == false {
                AlertHandler.showAlertWithTitle(title: "Message", message: "User denied permission to access Twitter account", handler: nil)
                let error = NSError(domain: "User denied permission to access Twitter account", code: 0, userInfo: nil)
                completionHandler(nil, error)
            }
            let accounts = self.accountStore.accounts(with: accountType) as! [ACAccount]
            if accounts.count != 0  {
                self.twitterAccount = accounts[0]
                completionHandler(self.twitterAccount,nil)
            }
            else{
                AlertHandler.showAlertWithTitle(title: "Message", message: "No Twitter account. Please add your twitter account in Settings.", handler: nil)
                let error = NSError(domain: "No Twitter account. Please add your twitter account in Settings.", code: 0, userInfo: nil)
                completionHandler(nil, error)
            }
        }
    }
    
    //MARK:- Initialize Fetch Result Controller
    func initializeFetchResultController()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: userNameString, ascending: true),NSSortDescriptor(key: "created_at", ascending: false)]
        self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainContextObject, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultController?.delegate = self
    }
    
    //MARK:- Update Time line after 120 seconds
    func updateTimeLine()
    {
        showNetworkActivityIndicator(isVisible: true)
        var itemCount = 0
        if let sections = fetchResultController?.sections {
            itemCount = sections[0].numberOfObjects
        }
        var    statusesShowEndpoint : String?
        if itemCount == 0 {
                statusesShowEndpoint =  "https://api.twitter.com/1.1/statuses/home_timeline.json?count=50"
      }else{
          if let since_id = UserDefaults.standard.value(forKey: sinceIDString)
          {
              let idStart = since_id
            statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json?count=\(tweetFetchCount)&since_id=\(idStart)"
            }
        }
        
        httpRequestSharedManager.getFeedbackListFromService(urlString: statusesShowEndpoint!, account: self.twitterAccount!, completion: {[weak self] (elementsArray, isSuccess) in
            if isSuccess {
                let notificationOperation = NotificationOperation(managedObjectContext: (self?.mainContextObject)!, elements: elementsArray!)
                self?.importOperationQueue.addOperation(notificationOperation)
                self?.showNetworkActivityIndicator(isVisible: false)
            }
        })
    }
    
    //MARK:- Show Network Activity Indicator for network call. As we are not using any HudView for operation
    func showNetworkActivityIndicator(isVisible : Bool)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
    }
    
    //MARK: - State Preservation & Restoration
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        let cell =  self.timeLineTableView.visibleCells.first as! CustomTableViewCell
        let indexPath =   self.timeLineTableView.indexPath(for: cell)
        if (indexPath?.row) != nil {
            coder.encode(indexPath, forKey: "cellRowId")
        }
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        if let indexPath =  coder.decodeObject(forKey: "cellRowId") as? IndexPath
        {
            UserDefaults.standard.set(indexPath.row+1, forKey: "cellRowId")
            UserDefaults.standard.synchronize()
        }
    }
    
//    //MARK:- Twitter Login Via Installed app
//    func loginUseViaTwitter()
//    {
//        Twitter.sharedInstance().logIn(completion: { (session, error) in
//            if (session != nil) {
//                print("signed in as \(String(describing: session?.userName))");
//                self.updateTimeLine()
//            } else {
//                print("error: \(String(describing: error?.localizedDescription))");
//            }
//        })
//    }
    
    
    // MARK: - Reload TableView
    private func authenticationSuccessHandler(action: UIAlertAction) {
        self.timeLineTableView.reloadData()
    }
    
    //MARK:- Async call of twitter user image download & save in codedata with image url
    func downloadImageForTwitterUser(user : TwitterUser, forCell cell : CustomTableViewCell)
    {
        if let image = UserImages.getImageForID(idString: user.id!, inContext: self.mainContextObject)        {
            cell.userProfileImage.image = image
        }
        else{
            cell.activityIndicator.startAnimating()
            if cell.imageDownloadDataTask != nil{
                cell.imageDownloadDataTask?.cancel()
            }
            cell.userProfileImage.image = nil
            let screeName = user.screen_name!
            let urlString = "https://twitter.com/\(screeName)/profile_image?size=normal"
            cell.imageDownloadDataTask  = self.urlSession?.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) in
                if error != nil{
                    print("Error in image download :\(String(describing: error?.localizedDescription))")
                }
                else
                {
                    let response = response as! HTTPURLResponse
                    if response.statusCode == 200
                    {
                        if  let image = UIImage(data: data!)
                        {
                            DispatchQueue.main.async {
                                cell.userProfileImage.image = image
                                cell.userProfileImage.contentMode = .scaleAspectFit
                                cell.activityIndicator.stopAnimating()
                                UserImages.saveImage(image: image, forIDString: user.id!, inContext: self.mainContextObject)
                               // self.saveImage(image: image, forURLString: url, inContext: self.mainContextObject)
                            }
                        }
                    }
                    else{
                        let error = NSError(domain: "", code: response.statusCode, userInfo: nil) as Error
                        print("Error in image download :\(String(describing: error.localizedDescription))")
                    }
                }
            })
            cell.imageDownloadDataTask?.resume()
        }
    }
    
    //Prepare cell
    func prepareCell(cell : CustomTableViewCell, indexPath : NSIndexPath)
    {
        if  let userData   = self.fetchResultController?.object(at: IndexPath(row: indexPath.row, section: indexPath.section)) as? TwitterUser
        {
            cell.userNameLabel.text = userData.name
            cell.tweetMessageLabel.text = userData.text
            self.downloadImageForTwitterUser(user: userData, forCell: cell)
        }
    }
}
