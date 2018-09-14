//
//  Extensions.swift
//  DMParallaxHeader
//
//  Created by Dominic on 9/10/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

extension NSObjectProtocol {
    func objectRespondsToSelector(_ object: NSObjectProtocol?, selector: Selector) -> Bool {
        guard let _object = object else { return false }
        return _object.responds(to: selector)
    }
}

extension UIScrollView {
    
    static var ParallaxHeaderKey = "kDMParallaxHeader"
    
    @objc public var parallaxHeader: DMParallaxHeader {
        get {
            var parallaxHeader = objc_getAssociatedObject(self, &UIScrollView.ParallaxHeaderKey) as? DMParallaxHeader
            if parallaxHeader == nil {
                parallaxHeader = DMParallaxHeader(frame: .zero)
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

extension UIScrollViewDelegate {
    func scrollView(_ scrollView: DMScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return true
    }
}
