//
//  DMFalconViewController.swift
//  DMParallaxHeaderExample
//
//  Created by Dominic Miller on 9/11/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit
import DMParallaxHeader

class DMFalconViewController: UIViewController, DMParallaxHeaderDelegate {
    
    @IBOutlet weak var falcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parallaxHeader?.delegate = self
    }
    
    // MARK: - DMParallaxHeaderDelegate
    
    func parallaxHeaderDidScroll(_ parallaxHeader: DMParallaxHeader) {
        let angle = parallaxHeader.progress * .pi * 2
        falcon.transform = CGAffineTransform.identity.rotated(by: angle)
    }
    
}

