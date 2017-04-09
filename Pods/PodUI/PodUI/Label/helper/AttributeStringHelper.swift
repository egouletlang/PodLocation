//
//  AttributeStringHelper.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/23/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

open class AttributeStringBuilder {
    
    /// Regex as defined on the server to validate an email address
    fileprivate static let emailValidatorRegex = try? NSRegularExpression(pattern: "^[^@]+@[^@]+\\.[^@]+$", options: [ NSRegularExpression.Options.anchorsMatchLines ])
    
    
    open class func formatString(_ raw: String?) -> LabelInformation? {
        return formatString(raw, withTextSize: nil, withLinks: nil, withColor: nil)
    }
    
    open class func formatString(_ raw: String?, withTextSize ts: Int? = nil, withLinks wl: Bool? = nil, withColor wc: String? = nil) -> LabelInformation? {
        
        let tSize = ts ?? 14
        let links = wl ?? true
        
        return formatString(raw, withTextSize: tSize, withLinks: links, withColor: wc)
        
    }
    
    open class func formatString(_ raw: String?, withTextSize ts: Int = 14, withLinks: Bool = true, withColor: String? = nil) -> LabelInformation? {
        let links = NSMutableArray()
        let linkLocations = NSMutableArray()
        let li = LabelInformation()
        li.attr = NSMutableAttributedString(string: "")
        
        if let _raw = raw {
            li.attr = AttributeStringCreator.build(_raw, Int32(ts), links, linkLocations, withColor)
        }
        
        if withLinks {
            for obj in links {
                if let link = obj as? NSString {
                    if let url = URL(string: link as String) {
                        li.links.append(url)
                    }
                }
            }
            
            for obj in linkLocations {
                if let range = (obj as AnyObject).rangeValue {
                    li.ranges.append(range)
                }
            }
        }
        return li
    }
    
    class func formatStringTruncates(_ raw: String?, withTextSize ts: Int = 14, withLinks: Bool = true) -> LabelInformation? {
        let li = formatString(raw, withTextSize: ts, withLinks: withLinks)
        if let attr = li?.attr  {
            let mutable = NSMutableAttributedString(attributedString: attr)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            mutable.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attr.length))
            li?.attr = mutable
        }
        return li
    }
    
    open class func stripOutTags(_ raw: String?) -> String? {
        let li = AttributeStringBuilder.formatString(raw)
        return li?.attr?.string
    }
}
