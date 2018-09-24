//
//  DMParallaxScrollView.swift
//  DMParallaxHeader
//
//  Created by Dominic on 9/10/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

/// The `DMScrollView` is a `UIScrollView` subclass with the ability to hook the vertical scroll from its subviews.
open class DMScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    static var KVOContext = "kDMScrollViewKVOContext"
    
    var forwarder: DMScrollViewDelegateForwarder!
    var observedViews = [UIScrollView]()
    
    /// - Warning: This value **must** be set as a `DMScrollViewDelegate`.
    override open var delegate: UIScrollViewDelegate? {
        get { return forwarder.delegate }
        set {
            forwarder.delegate = newValue as? DMScrollViewDelegate
            super.delegate = nil
            super.delegate = forwarder
        }
    }
    
    var isObserving: Bool = false
    var lock: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        forwarder = DMScrollViewDelegateForwarder(scrollView: self)
        super.delegate = forwarder
        showsVerticalScrollIndicator = false
        isDirectionalLockEnabled = true
        bounces = true
        panGestureRecognizer.cancelsTouchesInView = false
        observedViews = []
        addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset),
                    options:[.new, .old], context: &DMScrollView.KVOContext)
        isObserving = true
    }
    
    /*
     * MARK: - UIGestureRecognizerDelegate
     */
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view == self { return false }
        
        guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        // Lock horizontal pan gesture.
        let velocity = gestureRecognizer.velocity(in: self)
        if abs(velocity.x) > abs(velocity.y) { return false }
        
        // Consider scroll view pan only
        guard let scrollView = otherGestureRecognizer.view as? UIScrollView else { return false }
        
        // Tricky case: UITableViewWrapperView
        if scrollView.superview?.isKind(of: UITableView.self) ?? false { return false }
        
        let shouldScroll = forwarder.scrollView(self, shouldScrollWithSubView: scrollView)
        
        if shouldScroll {
            addObservedView(scrollView)
        }
        return shouldScroll
    }
    
    /*
     *  MARK: - KVO
     */
    
    func addObserver(to scrollView: UIScrollView) {
        lock = (scrollView.contentOffset.y > -scrollView.contentInset.top)
        
        scrollView.addObserver(self,
                               forKeyPath: #keyPath(UIScrollView.contentOffset),
                               options: [.old, .new],
                               context: &DMScrollView.KVOContext)
    }
    
    func removeObserver(from scrollView: UIScrollView) {
        scrollView.removeObserver(self,
                                  forKeyPath: #keyPath(UIScrollView.contentOffset),
                                  context: &DMScrollView.KVOContext)
    }
    
    //This is where the magic happens...
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &DMScrollView.KVOContext && keyPath == #keyPath(UIScrollView.contentOffset) else {
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
        guard let scrollView = object as? UIScrollView,
            let new = change?[.newKey] as? CGPoint,
            let old = change?[.oldKey] as? CGPoint else { return }
        let diff = old.y - new.y
        if diff == 0.0 || !isObserving { return }
        
        if scrollView === self {
            //Adjust self scroll offset when scroll down
            if diff > 0 && lock {
                self.scrollView(self, setContentOffset: old)
            } else if contentOffset.y < -contentInset.top && !bounces {
                self.scrollView(self, setContentOffset: CGPoint(x: contentOffset.x, y: -contentInset.top))
            } else if contentOffset.y > -parallaxHeader.minimumHeight {
                self.scrollView(self, setContentOffset: CGPoint(x: contentOffset.x, y: -parallaxHeader.minimumHeight))
            }
        } else {
            lock = scrollView.contentOffset.y > -scrollView.contentInset.top
            
            //Manage scroll up
            if contentOffset.y < -parallaxHeader.minimumHeight && lock && diff < 0 {
                self.scrollView(scrollView, setContentOffset: old)
            }
            //Disable bouncing when scroll down
            if !lock && (contentOffset.y > -contentInset.top || bounces) {
                self.scrollView(scrollView, setContentOffset: CGPoint(x: scrollView.contentOffset.x,
                                                                      y: -scrollView.contentInset.top))
            }
        }
    }
    
    /*
     *  MARK: - Scrolling Views Handlers
     */
    
    func addObservedView(_ scrollView: UIScrollView) {
        guard !observedViews.contains(scrollView) else { return }
        observedViews.append(scrollView)
        addObserver(to: scrollView)
    }
    
    func removeObservedViews() {
        observedViews.forEach { removeObserver(from: $0) }
        observedViews.removeAll()
    }
    
    func scrollView(_ scrollView: UIScrollView, setContentOffset offset: CGPoint) {
        isObserving = false
        scrollView.contentOffset = offset
        isObserving = true
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(contentOffset), context: &DMScrollView.KVOContext)
        removeObservedViews()
    }
    
    /*
     *  MARK: - UIScrollViewDelegate
     */
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lock = false
        removeObservedViews()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            lock = false
            removeObservedViews()
        }
    }
    
}
