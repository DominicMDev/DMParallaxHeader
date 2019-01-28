//
//  DMParallaxHeader.swift
//  DMParallaxHeader
//
//  Created by Dominic on 9/10/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit
import ObjectiveC

class DMParallaxView: UIView {
    
    static var KVOContext = "kDMParallaxViewKVOContext"
    
    weak var parent: DMParallaxHeader!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        defer { super.willMove(toSuperview: newSuperview) }
        guard let superView = self.superview as? UIScrollView else { return }
        superView.removeObserver(parent, forKeyPath: #keyPath(UIScrollView.contentOffset), context: &DMParallaxView.KVOContext)
        if #available(*, iOS 10) {
            superView.removeObserver(parent, forKeyPath: #keyPath(UIScrollView.contentInset), context: &DMParallaxView.KVOContext)
        }
    }
    
    override func didMoveToSuperview() {
        defer { super.didMoveToSuperview() }
        guard let superView = self.superview as? UIScrollView else { return }
        superView.addObserver(parent,
                              forKeyPath: #keyPath(UIScrollView.contentOffset),
                              context: &DMParallaxView.KVOContext)
        if #available(*, iOS 10) {
            superView.addObserver(parent,
                                  forKeyPath: #keyPath(UIScrollView.contentInset),
                                  context: &DMParallaxView.KVOContext)
        }
    }
}

/// The `DMParallaxHeader` class represents a parallax header for `UIScrollView`.
open class DMParallaxHeader: NSObject {
    
    /*
     * MARK: - Instance Properties
     */
    private var _extendsUnderNavigationBar: Bool = true
    
    /// Extends the parallax header under the navigation bar.
    /// - Important: This is obsoleted in iOS 11.
    @available(iOS, obsoleted: 11) public var extendsUnderNavigationBar: Bool {
        @available(iOS, obsoleted: 11)
        get { return _extendsUnderNavigationBar }
        @available(iOS, obsoleted: 11)
        set { _extendsUnderNavigationBar = newValue }
    }
    
    private var setContentInset: CGFloat?
    
    weak var scrollView: UIScrollView! {
        didSet {
            guard scrollView !== oldValue else { return }
            setContentInset = nil
            let inset = scrollView.contentInset.top + height
            adjustScrollViewTopInset(inset)
            setContentInset = inset
            scrollView.addSubview(contentView)
            layoutContentView()
            isObserving = true
        }
    }
    
    private var _contentView: UIView?
    
     /// The content view on top of the UIScrollView's content.
    public var contentView: UIView {
        if _contentView == nil {
            let contentView = DMParallaxView(frame: .zero)
            contentView.parent = self
            contentView.clipsToBounds = true
            _contentView = contentView
        }
        return _contentView!
    }
    
    var isObserving = false
    
    /// Delegate instance that adopt the DMScrollViewDelegate.
    @IBOutlet public weak var delegate: DMParallaxHeaderDelegate?
    
    /// The header's view.
    @IBOutlet public var view: UIView? {
        didSet {
            if view !== oldValue { updateConstraints() }
        }
    }
    
    /// The header's default height. 0 0 by default.
    @IBInspectable public var height: CGFloat = 0 {
        didSet {
            if height != oldValue {
                setContentInset = nil
                let inset = scrollView.contentInset.top - oldValue + height
                adjustScrollViewTopInset(inset)
                setContentInset = inset
                updateConstraints()
                layoutContentView()
            }
        }
    }
    
    /// The header's minimum height while scrolling up. 0 by default.
    @IBInspectable public var minimumHeight: CGFloat = 0 {
        didSet { layoutContentView() }
    }
    
    /// The parallax header behavior mode.
    public var mode: DMParallaxHeaderMode = .fill {
        didSet {
            if mode != oldValue { updateConstraints() }
        }
    }
    
    /// The parallax header progress value.
    public internal(set) var progress: CGFloat = 1 {
        didSet {
            guard progress != oldValue else { return }
            delegate?.parallaxHeaderDidScroll?(self)
        }
    }

    
    /*
     * MARK: - Constraints
     */
    
    open func updateConstraints() {
        guard let view = view else { return }
        view.removeFromSuperview()
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch (mode) {
        case .fill: setFillModeConstraints()
        case .topFill: setTopFillModeConstraints()
        case .top: setTopModeConstraints()
        case .bottom: setBottomModeConstraints()
        case .center: setCenterModeConstraints()
        }
    }
    
    func setCenterModeConstraints() {
        guard let view = view else { return }
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v": view]))
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setFillModeConstraints() {
        guard let view = view else { return }
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v":view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", metrics: nil,
                                                                  views: ["v":view]))
    }
    
    func setTopFillModeConstraints() {
        guard let view = view else { return }
        let metrics = ["highPriority" : UILayoutPriority.defaultHigh, "height" : height] as [String : Any]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v":view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v(>=height)]-0.0@highPriority-|",
                                                                  metrics: metrics, views:["v":view]))
    }
    
    func setTopModeConstraints() {
        guard let view = view else { return }
        let metrics = ["height" : height]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v":view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v(==height)]", metrics: metrics,
                                                                  views: ["v":view]))
    }
    
    func setBottomModeConstraints() {
        guard let view = view else { return }
        let metrics = ["height" : height]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v":view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v(==height)]|", metrics: metrics,
                                                                  views: ["v":view]))
    }
    
    /*
     * MARK: - Private Methods
     */
    
    func layoutContentView() {
        let minHeight   = min(minimumHeight, height)
        let relativeYOffset = scrollView.contentOffset.y + scrollView.contentInset.top - height
        let relativeHeight  = -relativeYOffset
        
        let frame = CGRect(x: 0, y: relativeYOffset,
                           width: scrollView.frame.width,
                           height: max(relativeHeight, minHeight))
        
        contentView.frame = frame
        
        let div = height - minimumHeight
        progress = (contentView.frame.height - minimumHeight) / div
    }
    
    func adjustScrollViewTopInset(_ top: CGFloat) {
        var inset = scrollView.contentInset
        var offset = scrollView.contentOffset
        
        offset.y += inset.top - top
        scrollView.contentOffset = offset
        
        inset.top = top
        scrollView.contentInset = inset
        
    }
    
    /*
     * MARK: - KVO
     */
    
    //This is where the magic happens...
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &DMParallaxView.KVOContext {
            if keyPath == #keyPath(UIScrollView.contentOffset) {
                layoutContentView()
            }
            if #available(*, iOS 10) {
                guard extendsUnderNavigationBar else { return }
                if keyPath == #keyPath(UIScrollView.contentInset) {
                    guard let newInset = (object as? UIScrollView)?.contentInset.top else { return }
                    if let inset = setContentInset, newInset != inset {
                        adjustScrollViewTopInset(inset)
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}
