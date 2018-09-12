//
//  DMScrollViewDelegateForwarder.swift
//  DMParallaxHeader
//
//  Created by Dominic Miller on 9/11/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

@objc class DMScrollViewDelegateForwarder: NSObject, UIScrollViewDelegate {
    
    @objc weak var delegate: UIScrollViewDelegate?
    @objc weak var scrollView: DMScrollView!
    
    init(scrollView: DMScrollView) {
        self.scrollView = scrollView
    }
    
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let selector = #selector(scrollViewDidScroll(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewDidScroll!(scrollView)
        }
    }
    
    @objc func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let selector = #selector(scrollViewDidZoom(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewDidZoom!(scrollView)
        }
    }
    
    @objc func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let selector = #selector(scrollViewWillBeginDragging(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewWillBeginDragging!(scrollView)
        }
    }
    
    @objc func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                                withVelocity velocity: CGPoint,
                                                targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let selector = #selector(scrollViewWillEndDragging(_:withVelocity:targetContentOffset:))
        if objectRespondsToSelector(delegate, selector: selector){
            delegate!.scrollViewWillEndDragging!(scrollView,
                                                 withVelocity: velocity,
                                                 targetContentOffset: targetContentOffset)
        }
    }
    
    @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollView.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        let selector = #selector(scrollViewDidEndDragging(_:willDecelerate:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
        }
    }
    
    @objc func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let selector = #selector(scrollViewWillBeginDecelerating(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewWillBeginDecelerating!(scrollView)
        }
    }
    
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollView.scrollViewDidEndDecelerating(scrollView)
        let selector = #selector(scrollViewDidEndDecelerating(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewDidEndDecelerating!(scrollView)
        }
    }
    
    @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let selector = #selector(scrollViewDidEndScrollingAnimation(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewDidEndScrollingAnimation!(scrollView)
        }
    }
    
    @objc func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let selector = #selector(viewForZooming(in:))
        if objectRespondsToSelector(delegate, selector: selector) {
            return delegate!.viewForZooming!(in: scrollView)
        }
        return nil
    }
    
    @objc func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        let selector = #selector(scrollViewWillBeginZooming(_:with:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewWillBeginZooming!(scrollView, with: view)
        }
    }
    
    @objc func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let selector = #selector(scrollViewDidEndZooming(_:with:atScale:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewDidEndZooming!(scrollView, with: view, atScale: scale)
        }
    }
    
    @objc func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        let selector = #selector(scrollViewShouldScrollToTop(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            return delegate!.scrollViewShouldScrollToTop!(scrollView)
        }
        return true
    }
    
    @objc func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        let selector = #selector(scrollViewDidScrollToTop(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewDidScrollToTop!(scrollView)
        }
    }
    
    @available(iOS 11.0, *)
    @objc func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        let selector = #selector(scrollViewDidChangeAdjustedContentInset(_:))
        if objectRespondsToSelector(delegate, selector: selector) {
            delegate!.scrollViewDidChangeAdjustedContentInset!(scrollView)
        }
    }
    
}









