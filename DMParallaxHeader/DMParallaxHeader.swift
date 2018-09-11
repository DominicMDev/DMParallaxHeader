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
    
    static var KVOContext = 0
    
    weak var parent: DMParallaxHeader!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        defer { super.willMove(toSuperview: newSuperview) }
        guard let superView = self.superview as? UIScrollView else { return }
        superView.removeObserver(parent, forKeyPath: #keyPath(UIScrollView.contentOffset), context: &DMParallaxView.KVOContext)
    }
    
    override func didMoveToSuperview() {
        defer { super.didMoveToSuperview() }
        guard let superView = self.superview as? UIScrollView else { return }
        superView.addObserver(parent,
                              forKeyPath: #keyPath(UIScrollView.contentOffset),
                              context: &DMParallaxView.KVOContext)
    }
}

public class DMParallaxHeader: UIView {
    
    /*
     * MARK: - Constants
     */
    
    static var KVOContext = 0
    
    /*
     * MARK: - Instance Properties
     */
    
    weak var scrollView: UIScrollView!
    
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
                adjustScrollViewTopInset(scrollView.contentInset.top - oldValue + height)
                updateConstraints()
                layoutContentView()
            }
        }
    }
    
    /// The header's minimum height while scrolling up. 0 by default.
    @IBInspectable public var minimumHeight: CGFloat = 0
    
    /// The parallax header behavior mode.
    public var mode: DMParallaxHeaderMode = .bottom {
        didSet {
            if mode != oldValue { updateConstraints() }
        }
    }
    
    /// The parallax header progress value.
    public internal(set) var progress: CGFloat = 1
    
    
    /*
     * MARK: - Constraints
     */
    
    override public func updateConstraints() {
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
                                                                  views: ["v" : view]))
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setFillModeConstraints() {
        guard let view = view else { return }
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v" : view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", metrics: nil,
                                                                  views: ["v" : view]))
    }
    
    func setTopFillModeConstraints() {
        guard let view = view else { return }
        let metrics = ["highPriority" : UILayoutPriority.defaultHigh, "height" : height] as [String : Any]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v" : view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v(>=height)]-0.0@highPriority-|",
                                                                  metrics: metrics, views:["v" : view]))
    }
    
    func setTopModeConstraints() {
        guard let view = view else { return }
        let metrics = ["height" : height]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v" : view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v(==height)]", metrics: metrics,
                                                                  views: ["v" : view]))
    }
    
    func setBottomModeConstraints() {
        guard let view = view else { return }
        let metrics = ["height" : height]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil,
                                                                  views: ["v" : view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v(==height)]|", metrics: metrics,
                                                                  views: ["v" : view]))
    }
    
    /*
     * MARK: - Private Methods
     */
    
    func layoutContentView() {
        let minimumHeight   = min(self.minimumHeight, height)
        let relativeYOffset = scrollView.contentOffset.y + scrollView.contentInset.top - height
        let relativeHeight  = -relativeYOffset
        
        let frame = CGRect(x: 0, y: relativeYOffset,
                           width: scrollView.frame.width, height: max(relativeHeight, minimumHeight))
        
        contentView.frame = frame
        
        let div = height - minimumHeight
        progress = (contentView.frame.height - minimumHeight) / (div != 0 ? 1 : height)
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
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &DMParallaxHeader.KVOContext {
            if keyPath == #keyPath(UIScrollView.contentOffset) {
                layoutContentView()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}

public extension UIScrollView {
    
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
