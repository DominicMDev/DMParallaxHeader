//
//  Segues.swift
//  DMParallaxHeader
//
//  Created by Dominic Miller on 9/18/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

/// The DMParallaxHeaderSegue class creates a segue object to get the parallax header view controller from storyboard.
public class DMParallaxHeaderSegue: UIStoryboardSegue {
    override public func perform() {
        guard source.isKind(of: DMScrollViewController.self) else { return }
        let svc = source as! DMScrollViewController
        svc.headerViewController = destination
    }
}

/// The DMScrollViewControllerSegue class creates a segue object to get the child view controller from storyboard.
public class DMScrollViewControllerSegue: UIStoryboardSegue {
    override public func perform() {
        guard source.isKind(of: DMScrollViewController.self) else { return }
        let svc = source as! DMScrollViewController
        svc.childViewController = destination
    }
}
