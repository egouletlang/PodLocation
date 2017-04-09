//
//  BaseUITextField.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class BaseUITextField: UITextField {
    
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    private var mayResign = true
    open func setDisallowResign() {
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
    
}
