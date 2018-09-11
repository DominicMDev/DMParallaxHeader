//
//  DMParallaxScrollView.swift
//  DMParallaxHeader
//
//  Created by Dominic on 9/10/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit

@objc public protocol DMScrollViewDelegate: UIScrollViewDelegate {
    
/**
 Asks the page if the scrollview should scroll with the subview.
 
 @param scrollView The scrollview. This is the object sending the message.
 @param subView    An instance of a sub view.
 
 @return YES to allow scrollview and subview to scroll together. YES by default.
 */
    @objc optional func scrollView(_ scrollView: DMParallaxScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool
}

public class DMParallaxScrollView: UIView, UIGestureRecognizerDelegate {
    
    static var KVOContext = "kDMScrollViewKVOContext"
    
    let scrollView: UIScrollView
    
    @IBOutlet weak var delegate: DMScrollViewDelegate? {
        didSet { scrollView.delegate = delegate }
    }
    
    var observedViews = [UIScrollView]()
    
    var isObserving: Bool = false
    var lock: Bool = false
    
    public override init(frame: CGRect) {
        self.scrollView = UIScrollView(frame: frame)
        super.init(frame: frame)
        addScrollView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.scrollView = UIScrollView(frame: .zero)
        super.init(coder: aDecoder)
        addScrollView()
    }
    
    private func initialize() {
        addScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.bounces = true
        scrollView.panGestureRecognizer.cancelsTouchesInView = false
        self.observedViews = []
        addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset),
                    options:[.new, .old], context: &DMParallaxScrollView.KVOContext)
        isObserving = true
    }
    
    private func addScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [scrollView.topAnchor.constraint(equalTo: topAnchor),
             scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
             scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
             scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)]
        )
        scrollView.delegate = delegate
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
        
        var shouldScroll = true
        if let delegate = delegate, delegate.responds(to: #selector(DMScrollViewDelegate.scrollView(_:shouldScrollWithSubView:))) {
            shouldScroll = delegate.scrollView!(self, shouldScrollWithSubView: scrollView)
        }
        
        if shouldScroll {
            // TODO
            // addObservedView(scrollView)
        }
        
        return shouldScroll
    }
    
    - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (otherGestureRecognizer.view == self) {
    return NO;
    }
    
    // Ignore other gesture than pan
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
    return NO;
    }
    
    // Lock horizontal pan gesture.
    CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
    if (fabs(velocity.x) > fabs(velocity.y)) {
    return NO;
    }
    
    // Consider scroll view pan only
    if (![otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
    return NO;
    }
    
    UIScrollView *scrollView = (id)otherGestureRecognizer.view;
    
    // Tricky case: UITableViewWrapperView
    if ([scrollView.superview isKindOfClass:[UITableView class]]) {
    return NO;
    }
    
    BOOL shouldScroll = YES;
    if ([self.delegate respondsToSelector:@selector(scrollView:shouldScrollWithSubView:)]) {
    shouldScroll = [self.delegate scrollView:self shouldScrollWithSubView:scrollView];;
    }
    
    if (shouldScroll) {
    [self addObservedView:scrollView];
    }
    
    return shouldScroll;
    }
    
    #pragma mark KVO
    
    - (void)addObserverToView:(UIScrollView *)scrollView {
    _lock = (scrollView.contentOffset.y > -scrollView.contentInset.top);
    
    [scrollView addObserver:self
    forKeyPath:NSStringFromSelector(@selector(contentOffset))
    options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
    context:kMXScrollViewKVOContext];
    }
    
    - (void)removeObserverFromView:(UIScrollView *)scrollView {
    @try {
    [scrollView removeObserver:self
    forKeyPath:NSStringFromSelector(@selector(contentOffset))
    context:kMXScrollViewKVOContext];
    }
    @catch (NSException *exception) {}
    }
    
    //This is where the magic happens...
    - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kMXScrollViewKVOContext && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
    
    CGPoint new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    CGPoint old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
    CGFloat diff = old.y - new.y;
    
    if (diff == 0.0 || !_isObserving) return;
    
    if (object == self) {
    
    //Adjust self scroll offset when scroll down
    if (diff > 0 && _lock) {
    [self scrollView:self setContentOffset:old];
    
    } else if (self.contentOffset.y < -self.contentInset.top && !self.bounces) {
    [self scrollView:self setContentOffset:CGPointMake(self.contentOffset.x, -self.contentInset.top)];
    } else if (self.contentOffset.y > -self.parallaxHeader.minimumHeight) {
    [self scrollView:self setContentOffset:CGPointMake(self.contentOffset.x, -self.parallaxHeader.minimumHeight)];
    }
    
    } else {
    //Adjust the observed scrollview's content offset
    UIScrollView *scrollView = object;
    _lock = (scrollView.contentOffset.y > -scrollView.contentInset.top);
    
    //Manage scroll up
    if (self.contentOffset.y < -self.parallaxHeader.minimumHeight && _lock && diff < 0) {
    [self scrollView:scrollView setContentOffset:old];
    }
    //Disable bouncing when scroll down
    if (!_lock && ((self.contentOffset.y > -self.contentInset.top) || self.bounces)) {
    [self scrollView:scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top)];
    }
    }
    } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    }
    
    #pragma mark Scrolling views handlers
    
    - (void)addObservedView:(UIScrollView *)scrollView {
    if (![self.observedViews containsObject:scrollView]) {
    [self.observedViews addObject:scrollView];
    [self addObserverToView:scrollView];
    }
    }
    
    - (void)removeObservedViews {
    for (UIScrollView *scrollView in self.observedViews) {
    [self removeObserverFromView:scrollView];
    }
    [self.observedViews removeAllObjects];
    }
    
    - (void)scrollView:(UIScrollView *)scrollView setContentOffset:(CGPoint)offset {
    _isObserving = NO;
    scrollView.contentOffset = offset;
    _isObserving = YES;
    }
    
    - (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kMXScrollViewKVOContext];
    [self removeObservedViews];
    }
    
    #pragma mark <UIScrollViewDelegate>
    
    - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _lock = NO;
    [self removeObservedViews];
    }
    
    - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
    _lock = NO;
    [self removeObservedViews];
    }
    }
    
    @end
    
    @implementation MXScrollViewDelegateForwarder
    
    - (BOOL)respondsToSelector:(SEL)selector {
    return [self.delegate respondsToSelector:selector] || [super respondsToSelector:selector];
    }
    
    - (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.delegate];
    }
    
    #pragma mark <UIScrollViewDelegate>
    
    - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [(MXScrollView *)scrollView scrollViewDidEndDecelerating:scrollView];
    if ([self.delegate respondsToSelector:_cmd]) {
    [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
    }
    
    - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [(MXScrollView *)scrollView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if ([self.delegate respondsToSelector:_cmd]) {
    [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    }
    
}
