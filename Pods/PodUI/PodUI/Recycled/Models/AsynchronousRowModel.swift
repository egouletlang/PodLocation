//
//  AsynchronousRowModel.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/24/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

private let LOADING_MESSAGE = "Loading"
private let ERROR_MESSAGE = "<center>Something went wrong<br><font color=\"#7B868C\">Tapped here to try again</font></center>"

private let ID = "AsynchronousRowModel"
open class AsynchronousRowModel: LabelRowModel {
    open class func isAsynchronousRowModel(id: String) -> Bool {
        return id == ID
    }
    override open func getId() -> String {
        return ID
    }
    
    // MARK: - Asynchronous Callbacks -
    public enum State {
        case INACTIVE
        case ACTIVE
        case ERROR
    }
    open var state = State.INACTIVE
    open var shouldAutoStart = true
    
    
    // MARK: - Inactive Label -
    open var inactiveLabel = LabelInformation()
    open var inactiveLabelMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withInactiveLabel(labelInfo li: LabelInformation) -> AsynchronousRowModel {
        self.setInactiveLabel(labelInfo: li)
        return self
    }
    open func withInactiveLabel(str: String? = nil,
                           textSize: Int? = nil,
                           textColor: String? = nil) -> AsynchronousRowModel {
        
        self.setInactiveLabel(str: str, textSize: textSize, textColor: textColor)
        return self
    }
    open func withInactiveLabel(margins m: Rect<CGFloat>? = nil) -> AsynchronousRowModel {
        self.setInactiveLabel(margins: m)
        return self
    }
    open func setInactiveLabel(labelInfo li: LabelInformation) {
        self.inactiveLabel = li
    }
    open func setInactiveLabel(str: String? = nil,
                  textSize: Int? = nil,
                  textColor: String? = nil) {
        
        guard let s = str else {
            self.inactiveLabel = LabelInformation()
            return
        }
        
        self.inactiveLabel = AttributeStringBuilder.formatString(s, withTextSize: textSize, withLinks: true, withColor: textColor) ?? LabelInformation()
        
    }
    open func setInactiveLabel(margins m: Rect<CGFloat>?) {
        self.inactiveLabelMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    // MARK: - Active Label -
    open var activeLabel = AttributeStringBuilder.formatString(LOADING_MESSAGE) ?? LabelInformation()
    open var activeLabelMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withActiveLabel(labelInfo li: LabelInformation) -> AsynchronousRowModel {
        self.setActiveLabel(labelInfo: li)
        return self
    }
    open func withActiveLabel(str: String? = nil,
                           textSize: Int? = nil,
                           textColor: String? = nil) -> AsynchronousRowModel {
        
        self.setActiveLabel(str: str, textSize: textSize, textColor: textColor)
        return self
    }
    open func withActiveLabel(margins m: Rect<CGFloat>? = nil) -> AsynchronousRowModel {
        self.setActiveLabel(margins: m)
        return self
    }
    open func setActiveLabel(labelInfo li: LabelInformation) {
        self.activeLabel = li
    }
    open func setActiveLabel(str: String? = nil,
                          textSize: Int? = nil,
                          textColor: String? = nil) {
        
        guard let s = str else {
            self.activeLabel = LabelInformation()
            return
        }
        
        self.activeLabel = AttributeStringBuilder.formatString(s, withTextSize: textSize, withLinks: true, withColor: textColor) ?? LabelInformation()
        
    }
    open func setActiveLabel(margins m: Rect<CGFloat>?) {
        self.activeLabelMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    // MARK: - Error Label -
    open var errorLabel = AttributeStringBuilder.formatString(ERROR_MESSAGE) ?? LabelInformation()
    open var errorLabelMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withErrorLabel(labelInfo li: LabelInformation) -> AsynchronousRowModel {
        self.setErrorLabel(labelInfo: li)
        return self
    }
    open func withErrorLabel(str: String? = nil,
                         textSize: Int? = nil,
                         textColor: String? = nil) -> AsynchronousRowModel {
        
        self.setErrorLabel(str: str, textSize: textSize, textColor: textColor)
        return self
    }
    open func withErrorLabel(margins m: Rect<CGFloat>? = nil) -> AsynchronousRowModel {
        self.setErrorLabel(margins: m)
        return self
    }
    open func setErrorLabel(labelInfo li: LabelInformation) {
        self.errorLabel = li
    }
    open func setErrorLabel(str: String? = nil,
                        textSize: Int? = nil,
                        textColor: String? = nil) {
        
        guard let s = str else {
            self.errorLabel = LabelInformation()
            return
        }
        
        self.errorLabel = AttributeStringBuilder.formatString(s, withTextSize: textSize, withLinks: true, withColor: textColor) ?? LabelInformation()
        
    }
    open func setErrorLabel(margins m: Rect<CGFloat>?) {
        self.errorLabelMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    
    open var request: (AsynchronousRowModel, AsynchronousRowView)->Void = { (_,_) in }
    open func withRequest(request: @escaping (AsynchronousRowModel, AsynchronousRowView)->Void) -> AsynchronousRowModel {
        self.setRequestTo(request: request)
        return self
    }
    open func setRequestTo(request: @escaping (AsynchronousRowModel, AsynchronousRowView)->Void) {
        self.request = request
    }
    
    open var spinnerColor: UIColor?
    open var spinnerMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withSpinner(color: UIColor? = nil, margins: Rect<CGFloat>? = nil) -> AsynchronousRowModel {
        self.setSpinnerTo(color: color, margins: margins)
        return self
    }
    open func setSpinnerTo(color: UIColor?, margins: Rect<CGFloat>?) {
        self.spinnerColor = color
        if let m = margins {
            self.spinnerMargins = m
        }
    }
}
