//
//  DMScrollViewDelegateForwarder.swift
//  DMParallaxHeader
//
//  Created by Dominic Miller on 9/11/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

@objc class DMScrollViewDelegateForwarder: NSObject, DMScrollViewDelegate {
    @objc weak var delegate: DMScrollViewDelegate?
    @objc weak var scrollView: DMScrollView!
    
    init(scrollView: DMScrollView) {
        self.scrollView = scrollView
    }
    
    @objc public func scrollView(_ scrollView: DMScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return delegate?.scrollView(scrollView, shouldScrollWithSubView: subView) ?? true
    }
    
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    @objc func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegate!.scrollViewDidZoom?(scrollView)
    }
    
    @objc func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    @objc func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                                withVelocity velocity: CGPoint,
                                                targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollViewWillEndDragging?(scrollView,
                                             withVelocity: velocity,
                                             targetContentOffset: targetContentOffset)
    }
    
    @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollView.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    @objc func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollView.scrollViewDidEndDecelerating(scrollView)
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    @objc func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return delegate?.viewForZooming?(in: scrollView)
    }
    
    @objc func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    @objc func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    @objc func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return delegate?.scrollViewShouldScrollToTop?(scrollView) ?? scrollView.scrollsToTop
    }
    
    @objc func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    @available(iOS 11.0, *)
    @objc func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}
