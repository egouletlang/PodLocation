//
//  SwipeActionModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/24/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class SwipeActionModel: NSObject {
    
    override public init() {
        super.init()
    }
    
    open var color: UIColor?
    open func withBackgroundColor(color: UIColor?) -> SwipeActionModel {
        self.setBackgroundColor(color: color)
        return self
    }
    open func setBackgroundColor(color: UIColor?) {
        self.color = color
    }
    
    open var title = LabelInformation()
    open func withTitle(labelInfo li: LabelInformation) -> SwipeActionModel {
        self.setTitle(labelInfo: li)
        return self
    }
    open func withTitle(str: String? = nil,
                        textSize: Int? = nil,
                        textColor: String? = nil) -> SwipeActionModel {
        
        self.setTitle(str: str, textSize: textSize, textColor: textColor)
        return self
    }
    open func setTitle(labelInfo li: LabelInformation) {
        self.title = li
    }
    open func setTitle(str: String? = nil,
                       textSize: Int? = nil,
                       textColor: String? = nil) {
        
        guard let s = str else {
            self.title = LabelInformation()
            return
        }
        
        self.title = AttributeStringBuilder.formatString(s, withTextSize: textSize, withLinks: true, withColor: textColor) ?? LabelInformation()
        
    }
    
    open var clickResponse: AnyObject?
    open func withClickResponse(obj: AnyObject?) -> SwipeActionModel {
        self.setClickResponseTo(obj: obj)
        return self
    }
    open func setClickResponseTo(obj: AnyObject?) {
        self.clickResponse = obj
    }
}
