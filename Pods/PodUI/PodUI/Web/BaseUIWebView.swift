//
//  BaseUIWebView.swift
//  bankroll
//
//  Created by Etienne Goulet-Lang on 7/4/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import BaseUtils

private let APPLE_WEB_DATA_SCHEME = "applewebdata"
private let DORADO_CLIENT_SCHEME = "dorado"

open class BaseUIWebView: UIWebView, UIWebViewDelegate {
    
    public init() {
        super.init(frame: CGRect.zero)
        self.__initialize()
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.__initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            self.delegate = self
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
    
    private func queryStringToDict(queryString: String?) -> (String, [String: AnyObject]) {
        var dict = [String: String]()
        
        if let query = queryString {
            for pair in query.characters.split(separator: "&").map(String.init) {
                let parts = pair.characters.split(separator: "=").map(String.init)
                if parts.count == 2 {
                    if let key = parts[0].removingPercentEncoding, let val = parts[1].removingPercentEncoding {
                        dict.updateValue(val, forKey: key)
                    }
                }
            }
        }
        
        return (dict.get("method") ?? "",
                JSONHelper.jsonStringToDict(str: dict.get("args")))
        
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        var requestURL = request.url
        if  let url = requestURL, url.scheme == APPLE_WEB_DATA_SCHEME {
            
            let trimmed = url.absoluteString.replacingOccurrences(of: "^(?:\(APPLE_WEB_DATA_SCHEME)://[0-9A-Z-]*/?)", with: "")
            
            if !trimmed.isEmpty {
                requestURL = URL(string: trimmed)
            }
        }
        
        if  let url = requestURL, url.scheme == DORADO_CLIENT_SCHEME {
            
            let (method, args) = queryStringToDict(queryString: requestURL!.query)
            
            if self.clientBridge(method: method, args: args) {
                return false
            }
        }
        return true
    }
    
    
    // Base UIView methods
    open func initialize() {}
    open func createAndAddSubviews() {}
    open func addGestureRecognition() {}
    open func removeGestureRecognition() {}
    open func frameUpdate() {}
    
    open func clientBridge(method: String, args: [String: AnyObject]) -> Bool { return false }
    
}
