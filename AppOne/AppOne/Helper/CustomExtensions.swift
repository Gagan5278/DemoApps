//
//  CustomExtensions.swift
//  AppOne
//
//  Created by  on 01/07/17.
//  Copyright © 2017 ., Pune. All rights reserved.
//

/*---------1. Extensions to place a subview in center of it's superview. 2. Color extextion to increase color brightness passed as apercetnage in function argument ---------*/

import Foundation
import UIKit

//MARK:- Extension to place subview in center of superview
extension UIView {
    
    func centerInSuperView()
    {
        self.centerHorizontalInSuperViwe()
        self.centreVerticallyInSuperView()
    }
    
    func centerHorizontalInSuperViwe()
    {
        let constraint1 = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0.0)
        self.superview?.addConstraints([constraint1])
    }
    
    func centreVerticallyInSuperView()
    {
        let constraint2 = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraints([constraint2])
    }
}

//MARK:- Extension for UICOlor to get dark & Light color based on percentage passed. Default is 30
extension UIColor {
    func adjustColor(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

