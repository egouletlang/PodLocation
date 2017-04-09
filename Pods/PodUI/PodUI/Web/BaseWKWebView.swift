//
//  BaseUIWebView.swift
//  bankroll
//
//  Created by Etienne Goulet-Lang on 6/20/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

import WebKit
import CoreGraphics
import UIKit

open class BaseWKWebView: WKWebView, WKNavigationDelegate {
    
    convenience public init(frame: CGRect) {
        self.init(frame: frame, configuration: WKWebViewConfiguration())
    }
    
    override public init(frame: CGRect, configuration: WKWebViewConfiguration) {
        
        if #available(iOS 9.0, *) {
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        } else {
            // Fallback on earlier versions
        }
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        super.init(frame: frame, configuration: configuration)
        
        __initialize()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var initialized = false
    private var currSize = CGSize.zero
    override open var frame: CGRect {
        didSet {
            self.frameDidSet()
        }
    }
    
    private func __initialize() {
        if !initialized {
            initialized = true
            self.navigationDelegate = self
            self.initialize()
            self.createAndAddSubviews()
            self.addGestureRecognition()
        }
    }
    private func frameDidSet() {
        if self.currSize != self.frame.size {
            self.currSize = self.frame.size
            self.frameUpdate()
        }
    }
    
    // Base UIView methods
    open func initialize() {}
    open func createAndAddSubviews() {}
    open func addGestureRecognition() {}
    open func removeGestureRecognition() {}
    open func frameUpdate() {}
    
    // MARK: - Helper methods for derived UIViews -
    private class CustomUILongPressGestureRecognizer: UILongPressGestureRecognizer {
        var selector: String?
    }
    func addTap(view: UIView, selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        tapGesture.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    func addLongPress(view: UIView, selector: String) {
        let longPressGesture = CustomUILongPressGestureRecognizer(target: self, action: Selector(("longPressDetected:")))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.selector = selector
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(longPressGesture)
    }
    func longPressDetected(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            if let selector = (sender as? CustomUILongPressGestureRecognizer)?.selector {
                Thread.detachNewThreadSelector(Selector(selector), toTarget:self, with: nil)
            }
        }
    }
    
       
}
