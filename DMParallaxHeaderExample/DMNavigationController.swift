//
//  DMWebViewController.swift
//  DMParallaxHeaderExample
//
//  Created by Dominic Miller on 9/11/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit
import WebKit
import DMParallaxHeader

class DMNavigationController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.navigationBar.isTranslucent =  true
        self.navigationBar.barTintColor = .clear
        self.navigationBar.backgroundColor = .clear
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
}

