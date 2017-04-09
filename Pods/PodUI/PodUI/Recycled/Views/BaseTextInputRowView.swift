//
//  BaseTextInputRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/22/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import BaseUtils

private let DEFAULT_HEIGHT: CGFloat = 44

open class BaseTextInputRowView: BaseRowView {
    
    // MARK: - UI -
    private let hintLabel = BaseUILabel(frame: CGRect.zero)
    private let charactersRemainingLabel = BaseUILabel(frame: CGRect.zero)
    private var charactersRemainingLabelSize = CGSize.zero
    
    // MARK: - Lifecycle -
    open override func createAndAddSubviews() {
        super.createAndAddSubviews()
        
        self.contentView.addSubview(hintLabel)
        hintLabel.font = UIFont.systemFont(ofSize: 14)
        hintLabel.textColor = UIColor(rgb: 0x7B868C)
        
        self.contentView.addSubview(charactersRemainingLabel)
        charactersRemainingLabel.textAlignment = .center
        charactersRemainingLabel.font = UIFont.systemFont(ofSize: 8)
        charactersRemainingLabel.textColor = UIColor(rgb: 0xFFFFFF)
        charactersRemainingLabel.padding = Rect<CGFloat>(5, 2, 5, 2)
        charactersRemainingLabel.layer.cornerRadius = 2
        charactersRemainingLabel.clipsToBounds = true
    }
    
    open override func frameUpdate() {
        super.frameUpdate()
        
        let hintMargins = (self.model as? BaseTextInputRowModel)?.hintMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        hintLabel.sizeToFit()
        
        hintLabel.frame.origin.x = hintMargins.left + leftEdge() + 8
        
        if self.centerHintAndCharLimUIVertically() {
            hintLabel.frame.origin.y = (self.contentView.frame.height - hintLabel.frame.height) / 2
        } else {
            hintLabel.frame.origin.y = hintMargins.top
        }
        
        let charLimitMargins = (self.model as? BaseTextInputRowModel)?.charLimitMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        charactersRemainingLabel.frame.size = charactersRemainingLabelSize
        charactersRemainingLabel.frame.origin.x = self.contentView.frame.width - self.charactersRemainingLabel.frame.width - charLimitMargins.right
        
        if self.centerHintAndCharLimUIVertically() {
            charactersRemainingLabel.frame.origin.y = (self.contentView.frame.height - self.charactersRemainingLabel.frame.height) / 2
        } else {
            charactersRemainingLabel.frame.origin.y = self.contentView.frame.height - self.charactersRemainingLabel.frame.height - charLimitMargins.bottom
        }
    }
    
    open override func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? BaseTextInputRowModel {
            
            hintLabel.labelInformation = m.hint
            
            charactersRemainingLabel.text = "\(m.maxCharLimit)"
            charactersRemainingLabel.sizeToFit()
            charactersRemainingLabelSize = charactersRemainingLabel.frame.size
            charactersRemainingLabel.backgroundColor = m.charLimitBackgroundColor ?? UIColor(rgb: 0xffffff)
            charactersRemainingLabel.isHidden = (m.maxCharLimit <= 0)
        }
    }
    
    // MARK: - Controlling
    private func hasCharLimit() -> Bool {
        if let m = self.model as? BaseTextInputRowModel {
            return (m.maxCharLimit > 0 || m.minCharLimit > 0)
        }
        return false
    }
    /// Method checks if the length is between the min and max number of characters
    open func isAcceptableLength(length: Int) -> Bool {
        var ret = true
        if let charLimit = (self.model as? BaseTextInputRowModel)?.maxCharLimit, charLimit > 0 {
            ret = ret && (length <= charLimit)
        }
        if let charLimit = (self.model as? BaseTextInputRowModel)?.minCharLimit, charLimit > 0 {
            ret = ret && (length >= charLimit)
        }
        return ret
    }
    
    open func initializeWithText(text: String?) {
        let length = text?.characters.count ?? 0
        ThreadHelper.checkedExecuteOnMainThread() {
            self.hintLabel.isHidden = (length != 0) // if we now have text - hide the hint
        }
        if let charLimit = (self.model as? BaseTextInputRowModel)?.maxCharLimit {
            ThreadHelper.checkedExecuteOnMainThread() {
                self.charactersRemainingLabel.text = "\(charLimit - length)"
            }
        }
    }
    /// Method checks a string for unnacceptable characters
    open func isAcceptableChars(str: String) -> Bool {
        if  let m = (self.model as? BaseTextInputRowModel),
            let accChar = (self.model as? BaseTextInputRowModel)?.acceptableCharacters {
            for c in str.characters {
                if accChar[c] == nil {
                    m.illegalCharacter(String(c))
                    return false
                }
            }
        }
        return true
    }
    /// Method checks to see if a new length will overflow, it also calls the underflow & overflow callbacks
    /// if it is defined
    open func willOverflow(length: Int) -> Bool {
        if  let model = self.model as? BaseTextInputRowModel,
            let charLimit = (self.model as? BaseTextInputRowModel)?.maxCharLimit, charLimit > 0 {
            if length > charLimit { model.overflow() }
            return length > charLimit
        }
        if  let model = self.model as? BaseTextInputRowModel,
            let charLimit = (self.model as? BaseTextInputRowModel)?.minCharLimit, charLimit > 0 {
            if length > charLimit { model.underflow() }
            //return length > charLimit
        }
        
        return false
    }
    /// Provide the current length and new length, this method is handles the hint and char length ui
    open func handleNewTextLength(oldLength: Int, newLength: Int) {
        if (oldLength == 0 && newLength != 0) || (oldLength != 0 && newLength == 0) {
            ThreadHelper.checkedExecuteOnMainThread() {
                self.hintLabel.isHidden = (oldLength == 0 && newLength != 0) // if we now have text - hide the hint
            }
        }
        if let charLimit = (self.model as? BaseTextInputRowModel)?.maxCharLimit {
            ThreadHelper.checkedExecuteOnMainThread() {
                self.charactersRemainingLabel.text = "\(charLimit - newLength)"
            }
        }
    }
    open func handleNewText(text: String?) {
        if let m = model {
            m.argCollectionObj = text as AnyObject?
            let newCanSubmit = isAcceptableLength(length: text?.characters.count ?? 0)
            if newCanSubmit != m.canSubmitArgs {
                m.canSubmitArgs = newCanSubmit
                (self.model as? BaseTextInputRowModel)?.hasText(newCanSubmit)
                self.baseRowViewDelegate?.submitArgsValidityChanged?(valid: newCanSubmit)
            }
        }
        (self.model as? BaseTextInputRowModel)?.textChanged(text ?? "")
        
        
        self.baseRowViewDelegate?.submitArgsChanged?()
    }
    
    open func centerHintAndCharLimUIVertically() -> Bool {
        return true
    }
    open func inputFrame() -> CGRect {
        if centerHintAndCharLimUIVertically() {
            let charactersRemainingLabelWidth = (charactersRemainingLabel.isHidden) ? 0 : charactersRemainingLabel.frame.width
            return CGRect(x: leftEdge(), y: 0,
                          width: rightEdge() - leftEdge() - charactersRemainingLabelWidth,
                          height: self.contentView.frame.height)
        } else {
            let charactersRemainingLabelHeight = (charactersRemainingLabel.isHidden) ? 0 : charactersRemainingLabel.frame.height
            return CGRect(x: leftEdge(), y: 0,
                          width: rightEdge() - leftEdge(),
                          height: self.contentView.frame.height - charactersRemainingLabelHeight)
        }
    }
    
    open func leftEdge() -> CGFloat {
        return 0
    }
    open func rightEdge() -> CGFloat {
        return self.contentView.frame.width
    }
    
    
    
    override open func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        
        let height = (model.size.height > 0) ? model.size.height: DEFAULT_HEIGHT
        let width = (model.size.width > 0) ? model.size.width: w
        
        return CGSize(width: width, height: height)
        
    }
    
}
