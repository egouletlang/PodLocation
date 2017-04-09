//
//  LabelRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/6/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

private let BACKGROUND_COLOR = UIColor(rgb: 0xF8F8F8)

private let LABEL_ROW_ID = "LabelRowModel"
open class LabelRowModel: BaseRowModel {
    
    open static let DEFAULT_IOS_ROW_HEIGHT: CGFloat = 50
    open func withDefaultIOSRowHeight() -> LabelRowModel {
        self.setHeightTo(height: LabelRowModel.DEFAULT_IOS_ROW_HEIGHT)
        return self
    }
    
    open class func buildSectionTitleRow(
        title: String? = nil,
        titleTextColor: String? = "#7B868C",
        height: CGFloat = 20,
        topBorder: Bool = false,
        bottomBorder: Bool = false) -> LabelRowModel {
        var formattedTitle = title
        if (title != nil) && (titleTextColor != nil) {
            formattedTitle = String(format: "<font color=\"%@\">%@</font>", arguments: [
                titleTextColor!,
                title!
                ])
        }
        return LabelRowModel()
            .withTitle(str: formattedTitle, textSize: 12)
            .withHeight(height: height)
            .withPadding(l: 15, t: height - 5, b: 0)
            .withBorders(t: topBorder, b: bottomBorder)
            .withBackgroundColor(color: BACKGROUND_COLOR) as! LabelRowModel
    }
    
    open class func buildSectionFooterRow(
        title: String? = nil,
        titleTextColor: String? = "#7B868C",
        height: CGFloat = 20,
        topBorder: Bool = false,
        bottomBorder: Bool = false) -> LabelRowModel {
        var formattedTitle = title
        if (title != nil) && (titleTextColor != nil) {
            formattedTitle = String(format: "<font color=\"%@\">%@</font>", arguments: [
                titleTextColor!,
                title!
                ])
        }
        return LabelRowModel()
            .declareIsFooter()
            .withTitle(str: formattedTitle, textSize: 12)
            .withHeight(height: height)
            .withPadding(l: 15, t: 0, b: height - 5)
            .withBorders(t: topBorder, b: bottomBorder)
            .withBackgroundColor(color: BACKGROUND_COLOR) as! LabelRowModel
    }
    
    
    // ====================================================
    // | Title                                            |
    // | Subtitle                                         |
    // | Detail                                           |
    // ====================================================
    
    override open func getId() -> String {
        return LABEL_ROW_ID
    }
    
    open class func isLabelRowModel(id: String) -> Bool {
        return id == LABEL_ROW_ID
    }
    
    open var isFooter = false
    fileprivate func declareIsFooter() -> LabelRowModel {
        self.isFooter = true
        return self
    }
    
    // MARK: - Title Label -
    open var title = LabelInformation()
    open var titleNumberOfLines = 0
    open var titleMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withTitle(labelInfo li: LabelInformation) -> LabelRowModel {
        self.setTitle(labelInfo: li)
        return self
    }
    open func withTitle(str: String? = nil,
                        textSize: Int? = nil,
                        textColor: String? = nil) -> LabelRowModel {
        
        self.setTitle(str: str, textSize: textSize, textColor: textColor)
        return self
    }
    open func withTitle(numberOfLines: Int) -> LabelRowModel {
        self.setTitle(numberOfLines: numberOfLines)
        return self
    }
    open func withTitle(margins m: Rect<CGFloat>? = nil) -> LabelRowModel {
        self.setTitle(margins: m)
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
    open func setTitle(numberOfLines: Int) {
        self.titleNumberOfLines = numberOfLines
    }
    open func setTitle(margins m: Rect<CGFloat>?) {
        self.titleMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    // MARK: - Subtitle Label -
    open var subTitle = LabelInformation()
    open var subTitleNumberOfLines = 0
    open var subTitleMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withSubTitle(labelInfo li: LabelInformation) -> LabelRowModel {
        self.setSubTitle(labelInfo: li)
        return self
    }
    open func withSubTitle(str: String? = nil,
                           textSize: Int? = nil,
                           textColor: String? = nil) -> LabelRowModel {
        
        self.setSubTitle(str: str, textSize: textSize, textColor: textColor)
        return self
    }
    open func withSubTitle(numberOfLines: Int) -> LabelRowModel {
        self.setSubTitle(numberOfLines: numberOfLines)
        return self
    }
    open func withSubTitle(margins m: Rect<CGFloat>? = nil) -> LabelRowModel {
        self.setSubTitle(margins: m)
        return self
    }
    open func setSubTitle(labelInfo li: LabelInformation) {
        self.subTitle = li
    }
    open func setSubTitle(str: String? = nil,
                          textSize: Int? = nil,
                          textColor: String? = nil) {
        
        guard let s = str else {
            self.subTitle = LabelInformation()
            return
        }
        
        self.subTitle = AttributeStringBuilder.formatString(s, withTextSize: textSize, withLinks: true, withColor: textColor) ?? LabelInformation()
        
    }
    open func setSubTitle(numberOfLines: Int) {
        self.subTitleNumberOfLines = numberOfLines
    }
    open func setSubTitle(margins m: Rect<CGFloat>?) {
        self.subTitleMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    
    // MARK: - Detail Label -
    open var details = LabelInformation()
    open var detailsNumberOfLines = 0
    open var detailsMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withDetails(labelInfo li: LabelInformation) -> LabelRowModel {
        self.setDetails(labelInfo: li)
        return self
    }
    open func withDetails(str: String? = nil,
                         textSize: Int? = nil,
                         textColor: String? = nil) -> LabelRowModel {
        
        self.setDetails(str: str, textSize: textSize, textColor: textColor)
        return self
    }
    open func withDetails(numberOfLines: Int) -> LabelRowModel {
        self.setDetails(numberOfLines: numberOfLines)
        return self
    }
    open func withDetails(margins m: Rect<CGFloat>? = nil) -> LabelRowModel {
        self.setDetails(margins: m)
        return self
    }
    open func setDetails(labelInfo li: LabelInformation) {
        self.details = li
    }
    open func setDetails(str: String? = nil,
                        textSize: Int? = nil,
                        textColor: String? = nil) {
        
        guard let s = str else {
            self.details = LabelInformation()
            return
        }
        
        self.details = AttributeStringBuilder.formatString(s, withTextSize: textSize, withLinks: true, withColor: textColor) ?? LabelInformation()
        
    }
    open func setDetails(numberOfLines: Int) {
        self.detailsNumberOfLines = numberOfLines
    }
    open func setDetails(margins m: Rect<CGFloat>?) {
        self.detailsMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    override open func withDefaultBottomBorder() -> BaseRowModel {
        let minMargin = min(min(self.titleMargins.left, self.subTitleMargins.left), self.detailsMargins.left)
        self.setBottomBorderTo(show: true, padding: Rect<CGFloat>(self.padding.left + minMargin, 0, 0, 0))
        return self
    }
}
