//
//  ParallaxHeaderExtensions.swift
//  DMParallaxHeader
//
//  Created by Dominic on 9/10/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    static var ParallaxHeaderKey = "kDMParallaxHeader"
    
    @IBOutlet public var parallaxHeader: DMParallaxHeader! {
        get {
            var parallaxHeader = objc_getAssociatedObject(self, &UIScrollView.ParallaxHeaderKey) as? DMParallaxHeader
            if parallaxHeader == nil {
                parallaxHeader = DMParallaxHeader()
                self.parallaxHeader = parallaxHeader!
            }
            return parallaxHeader!
        }
        set {
            newValue.scrollView = self
            objc_setAssociatedObject(self, &UIScrollView.ParallaxHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension UIViewController {
    
    public var parallaxHeader: DMParallaxHeader? {
        let parallaxHeader = objc_getAssociatedObject(self, &UIScrollView.ParallaxHeaderKey) as? DMParallaxHeader
        if parallaxHeader == nil && parent != nil {
            return parent!.parallaxHeader
        }
        return parallaxHeader
    }
    
}
