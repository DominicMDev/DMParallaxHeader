//
//  DMScrollViewController.swift
//  DMParallaxHeader
//
//  Created by Dominic Miller on 9/11/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit
import ObjectiveC

@objc open class DMScrollViewController: UIViewController {
    
    static var KVOContext = "kDMScrollViewControllerKVOContext"
    
    @IBOutlet weak var headerView: UIView?
    @IBInspectable var headerHeight: CGFloat = 100
    @IBInspectable var headerMinimumHeight: CGFloat = 0
    
    /// The scroll view container
    var _scrollView: DMScrollView?
    public var scrollView: DMScrollView {
        if _scrollView == nil {
            _scrollView = DMScrollView(frame: .zero)
            _scrollView!.parallaxHeader.addObserver(self,
                                                   forKeyPath:#keyPath(DMParallaxHeader.minimumHeight),
                                                   options: .new,
                                                   context: &DMScrollViewController.KVOContext)
        }
        return _scrollView!
    }
    
    /// The parallax header view controller to be added to the scroll view
    public var headerViewController: UIViewController? {
        willSet {
            if let _headerViewController = headerViewController, _headerViewController.parent == self {
                _headerViewController.willMove(toParent: nil)
                _headerViewController.view.removeFromSuperview()
                _headerViewController.removeFromParent()
                _headerViewController.didMove(toParent: nil)
            }
            
            if let headerViewController = newValue {
                headerViewController.willMove(toParent: self)
                addChild(headerViewController)
                
                //Set parallaxHeader view
                objc_setAssociatedObject(headerViewController,
                                         &UIScrollView.ParallaxHeaderKey,
                                         scrollView.parallaxHeader,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                scrollView.parallaxHeader.view = headerViewController.view
                headerViewController.didMove(toParent: self)
            }
        }
    }
    
    /// The child view controller to be added to the scroll view
    public var childViewController: UIViewController? {
        willSet {
            if let _childViewController = childViewController, _childViewController.parent == self {
                _childViewController.willMove(toParent: nil)
                _childViewController.view.removeFromSuperview()
                _childViewController.removeFromParent()
                _childViewController.didMove(toParent: nil)
            }
            
            if let childViewController = newValue {
                childViewController.willMove(toParent: self)
                addChild(childViewController)
                
                //Set UIViewController's parallaxHeader property
                objc_setAssociatedObject(childViewController,
                                         &UIScrollView.ParallaxHeaderKey,
                                         scrollView.parallaxHeader,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                scrollView.addSubview(childViewController.view)
                childViewController.didMove(toParent: self)
            }
        }
    }
    
    /*
     *  MARK: - View Life Cycle
     */
    
    override open func loadView() {
        view = scrollView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = headerHeight
        scrollView.parallaxHeader.minimumHeight = headerMinimumHeight
        
        //Hack to perform segues on load
        
        let templates = value(forKey: "storyboardSegueTemplates") as! [AnyObject]
        for item in templates {
            print(String(describing: item.self))
            print(String(describing: item.value(forKey: "identifier")))
            print("")
        }
        let this = String(describing: DMScrollViewControllerSegue.self)
        print(this)
        print(this)
        print(this)
        for template in templates {
            let segueClassName = String(template.value(forKey:"_segueClassName") as! NSString)
            if segueClassName.contains(String(describing: DMScrollViewControllerSegue.self)) ||
                segueClassName.contains(String(describing: DMParallaxHeaderSegue.self)) {
                let identifier = template.value(forKey: "identifier") as! String
                performSegue(withIdentifier: identifier, sender: self)
            }
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = scrollView.frame.size
        layoutChildViewController()
    }
    
    func layoutChildViewController() {
        var frame = scrollView.frame
        frame.origin = .zero
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        childViewController?.view.frame = frame;
    }
    
    /*
     *  MARK: - KVO
     */
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &DMScrollViewController.KVOContext else {
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        if childViewController != nil && keyPath == #keyPath(DMParallaxHeader.minimumHeight) {
            layoutChildViewController()
        }
    }
    
    deinit {
        scrollView.parallaxHeader.removeObserver(self, forKeyPath: #keyPath(DMParallaxHeader.minimumHeight))
    }
    
}
