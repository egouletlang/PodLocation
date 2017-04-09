//
//  BaseTextInputRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/22/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

open class BaseTextInputRowModel: BaseRowModel {
    
    // NO ID - this model does not directly correspond to a view. It should be the parent for text input models
    // and contains their common logic.
    
    // MARK: - Constants -
    open static let LETTERS_NUMBERS_UNDERSCORES: [Character: Bool] = {
        var ret = [Character: Bool]()
        BaseTextInputRowModel.addLetters(ret: &ret)
        BaseTextInputRowModel.addNumbers(ret: &ret)
        BaseTextInputRowModel.addUnderscore(ret: &ret)
        return ret
    }()
    private class func addLetters(ret: inout [Character: Bool]) {
        for char in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".characters {
            ret[char] = true
        }
    }
    private class func addNumbers(ret: inout [Character: Bool]) {
        for char in "1234567890".characters {
            ret[char] = true
        }
    }
    private class func addUnderscore(ret: inout [Character: Bool]) {
        for char in "_".characters {
            ret[char] = true
        }
    }
    
    open var autoCorrection: Bool? = nil
    open func with(autoCorrect b: Bool?) -> BaseTextInputRowModel {
        self.autoCorrection = b
        return self
    }
    
    // MARK: - Hint -
    open var hint = LabelInformation()
    open var hintMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withHint(labelInfo li: LabelInformation) -> BaseTextInputRowModel {
        self.setHint(labelInfo: li)
        return self
    }
    open func withHint(str: String? = nil,
                  textSize: Int? = nil,
                  textColor: String? = nil) -> BaseTextInputRowModel {
        self.setHint(str: str, textSize: textSize, textColor: textColor)
        return self
    }
    open func withHint(margins m: Rect<CGFloat>? = nil) -> BaseTextInputRowModel {
        self.setHint(margins: m)
        return self
    }
    open func setHint(labelInfo li: LabelInformation) {
        self.hint = li
    }
    open func setHint(str: String? = nil,
                 textSize: Int? = nil,
                 textColor: String? = nil) {
        
        self.hint = AttributeStringBuilder.formatString(str, withTextSize: textSize, withLinks: true, withColor: textColor) ?? LabelInformation()
    }
    open func setHint(margins m: Rect<CGFloat>?) {
        self.hintMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    // MARK: - Character Limit -
    open var minCharLimit = 0 // charLimit <= 0 means no limited
    open var maxCharLimit = 0 // charLimit <= 0 means no limited
    open var charLimitBackgroundColor: UIColor?
    open var charLimitMargins = Rect<CGFloat>(0, 0, 0, 0)
    open func withCharLimit(minLimit: Int? = nil, maxLimit: Int? = nil, backgroundColor: UIColor? = nil, margins: Rect<CGFloat>? = nil) -> BaseTextInputRowModel {
        self.setCharLimitTo(minLimit: minLimit, maxLimit: maxLimit, backgroundColor: backgroundColor, margins: margins)
        return self
    }
    open func setCharLimitTo(minLimit: Int?, maxLimit: Int?, backgroundColor: UIColor?, margins: Rect<CGFloat>?) {
        if let l = minLimit {
            self.minCharLimit = l
        }
        if let l = maxLimit {
            self.maxCharLimit = l
        }
        if let b = backgroundColor {
            self.charLimitBackgroundColor = b
        }
        if let m = margins {
            self.charLimitMargins = m
        }
    }
    
    //MARK: - Callbacks -
    open var overflow: ()->Void = {}
    open var underflow: ()->Void = {}
    open var illegalCharacter: (String)->Void = { (_) in }
    open var hasText: (Bool)->Void = { (_) in }
    open var textChanged: (String)->Void = { (_) in }
    open func withCallbacks(hasText: ((Bool)->Void)? = nil, textChanged: ((String)->Void)? = nil, illegalCharacter: ((String)->Void)? = nil, overflow: (()->Void)? = nil, underflow: (()->Void)? = nil) -> BaseTextInputRowModel {
        self.setCallbacksTo(hasText: hasText, textChanged: textChanged, illegalCharacter: illegalCharacter, overflow: overflow, underflow: underflow)
        return self
    }
    open func setCallbacksTo(hasText: ((Bool)->Void)?, textChanged: ((String)->Void)?, illegalCharacter: ((String)->Void)?, overflow: (()->Void)?, underflow: (()->Void)?) {
        if let c = hasText {
            self.hasText = c
        }
        if let c = textChanged {
            self.textChanged = c
        }
        if let c = illegalCharacter {
            self.illegalCharacter = c
        }
        if let c = overflow {
            self.overflow = c
        }
        if let c = underflow {
            self.underflow = c
        }
    }
    
    // MARK: - Acceptable Characters -
    open var acceptableCharacters: [Character: Bool]?
    open func withLettersNumbersAndUnderscore() -> BaseTextInputRowModel {
        return withAcceptableCharacters(chars: BaseTextInputRowModel.LETTERS_NUMBERS_UNDERSCORES)
    }
    open func withAcceptableCharacters(str: String? = nil) -> BaseTextInputRowModel {
        if let s = str {
            var ret = [Character: Bool]()
            for char in s.characters {
                ret[char] = true
            }
            self.setAcceptableCharactersTo(char: ret)
        }
        return self
    }
    open func withAcceptableCharacters(chars: [Character: Bool]? = nil) -> BaseTextInputRowModel {
        self.setAcceptableCharactersTo(char: chars)
        return self
    }
    open func setAcceptableCharactersTo(char: [Character: Bool]?) {
        self.acceptableCharacters = char
    }
    
    open override func canCollectArgs() -> Bool {
        return true
    }
    
    open override func cleanUp() {
        super.cleanUp()
        self.hasText = { (_) in }
        self.textChanged = { (_) in }
        self.illegalCharacter = { (_) in }
        self.overflow = {}
        self.underflow = {}
    }
    
}
