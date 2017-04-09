//
//  BaseUIView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/6/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import BaseUtils

/// The base UIView relies on updating the component's frame. There is no support of constraints.
open class BaseUIView: UIView, UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - FirstResponder -
    
    private var mayResign = true
    func setDisallowResign() {
        mayResign = false
    }
    
    open func setAllowResign() {
        mayResign = true
    }
    
    override open var canResignFirstResponder: Bool {
        get {
            return mayResign
        }
    }
    
    // MARK: - Constructors -
    public init() {
        super.init(frame: CGRect.zero)
        self.__initialize()
    }
    
    public init(config: BaseUIViewConfig?) {
        super.init(frame: CGRect.zero)
        self.config = config
        self.__initialize()
    }
    
    open var config: BaseUIViewConfig?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.__initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.removeGestureRecognition()
    }
    
    // MARK: - Configuration -
    fileprivate var initialized = false
    fileprivate func __initialize() {
        if !initialized {
            initialized = true
            self.initialize()
            self.createAndAddSubviews()
            self.addGestureRecognition()
        }
    }
    
    // MARK: - Responding to Frame Changes -
    fileprivate var currSize = CGSize.zero
    override open var frame: CGRect {
        didSet {
            self.frameDidSet()
        }
    }
    // only respond to frame updates if the size changes to avoid over-drawing.
    fileprivate func frameDidSet() {
        if self.currSize != self.frame.size {
            self.currSize = self.frame.size
            self.frameUpdate()
        }
    }
    
    // MARK: - Redraw optimizations -
    override open func setNeedsDisplay() {
        ThreadHelper.checkedExecuteOnMainThread() {
            super.setNeedsDisplay()
        }
    }
    
    // MARK: - View Controller Functionality Delegate -
    open weak var baseUIViewDelegate: BaseUIViewDelegate? {
        didSet {
            for subview in self.subviews {
                (subview as? BaseUIView)?.baseUIViewDelegate = self.baseUIViewDelegate
            }
        }
    }
    
    // MARK: - Touch -
    open var passThroughDefault = false
    open func forcePassThroughHitTest() -> Bool {
        return passThroughDefault
    }
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if forcePassThroughHitTest() && view == self {
            return nil
        }
        return view
    }
    open func addTap(_ view: UIView, selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    open func addLongPress(_ view: UIView, selector: String) {
        let longPressGesture = CustomUILongPressGestureRecognizer(target: self, action: #selector(BaseUIView.longPressDetected(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.selector = selector
        longPressGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(longPressGesture)
    }
    func longPressDetected(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            if let selector = (sender as? CustomUILongPressGestureRecognizer)?.selector {
                Thread.detachNewThreadSelector(Selector(selector), toTarget:self, with: nil)
            }
        }
    }
    
    
    fileprivate class CustomUILongPressGestureRecognizer: UILongPressGestureRecognizer {
        var selector: String?
    }
    
    // MARK: - Animations -
    fileprivate let DEFAULT_DURATION: TimeInterval = 0.3
    open func animate(_ block: @escaping ()->Void) {
        UIView.animate(
            withDuration: DEFAULT_DURATION,
            delay: 0,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: block,
            completion: nil)
    }
    
    
    // MARK: - Lifecycle methods which may be implemented by derived classes -
    open func initialize() {}
    open func createAndAddSubviews() {}
    open func addGestureRecognition() {}
    open func removeGestureRecognition() {}
    open func frameUpdate() {}
    
    
}

