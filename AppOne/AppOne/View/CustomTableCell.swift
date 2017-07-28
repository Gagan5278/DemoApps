//
//  ViewController.swift
//  AppOne
//
//  Created by  on 01/07/17.
//  Copyright © 2017 , Pune. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //Return cell identifier
    static func indentifier() -> String{
        return self.description()
    }

}
