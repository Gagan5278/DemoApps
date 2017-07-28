//
//  CustomTableViewCell.swift
//  TwitterDemo
//
//  Created by  on 03/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/***----UITableViewCell subclass to show user's image, name & message in cell----***/

import UIKit

class CustomTableViewCell: UITableViewCell {

    //Twitter user image
    @IBOutlet weak var userProfileImage: UIImageView!
    //ActivityIndicator to show user image download progress
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Twitter Message label
    @IBOutlet weak var tweetMessageLabel: UILabel!
    //Twitter user name
    @IBOutlet weak var userNameLabel: UILabel!
    //URLSessionDataTask object to download user image from Twitter
    var imageDownloadDataTask : URLSessionDataTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }    
}
