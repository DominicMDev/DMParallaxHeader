//
//  Delegates.swift
//  DMParallaxHeader
//
//  Created by Dominic on 9/10/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

///The delegate of a `DMParallaxHeader` object may adopt the
/// `DMParallaxHeaderDelegate` protocol to respond to scoll from the parallaxHeader instance.
@objc public protocol DMParallaxHeaderDelegate: NSObjectProtocol {
    
    /// Tells the header view that the parallax header did scroll.
    /// The view typically implements this method to obtain the change in progress from parallaxHeaderView.
    ///
    /// - Parameter parallaxHeader: The parallax header that scrolls.
    @objc optional func parallaxHeaderDidScroll(_ parallaxHeader: DMParallaxHeader)
    
}

/// The delegate of a `DMScrollView` object may adopt the
/// `DMScrollViewDelegate` protocol to control subview's scrolling effect.
@objc public protocol DMScrollViewDelegate: UIScrollViewDelegate {
    
    /// Asks the page if the scrollview should scroll with the subview.
    ///
    /// - Parameters:
    ///   - scrollView: The scrollview. This is the object sending the message.
    ///   - subView: An instance of a sub view.
    /// - Returns: true to allow scrollview and subview to scroll together. Default is true.
    @objc func scrollView(_ scrollView: DMScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool
}

