//
//  DMParallaxHeaderDelegate.swift
//  DMParallaxHeader
//
//  Created by Dominic on 9/10/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

@objc public protocol DMParallaxHeaderDelegate: NSObjectProtocol {
    /**
     Tells the header view that the parallax header did scroll.
     The view typically implements this method to obtain the change in progress from parallaxHeaderView.
     
     @param parallaxHeader The parallax header that scrolls.
     */
    @objc optional func parallaxHeaderDidScroll(_ parallaxHeader: DMParallaxHeader)
    
}
