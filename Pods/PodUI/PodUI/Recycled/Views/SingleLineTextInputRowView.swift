//
//  SingleLineTextInputRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/23/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

open class SingleLineTextInputRowView: BaseTextInputRowView, UITextFieldDelegate {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var currText: String?
    
    // MARK: - UI -
    private let textField = BaseUITextField(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    open override func createAndAddSubviews() {
        super.createAndAddSubviews()
        
        self.contentView.addSubview(textField)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.delegate = self
        textField.backgroundColor = UIColor.clear
    }
    
    open override func addGestureRecognition() {
        super.addGestureRecognition()
        NotificationCenter.default.addObserver(self, selector: #selector(SingleLineTextInputRowView.textFieldDidChange(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    open override func frameUpdate() {
        super.frameUpdate()
        textField.frame = self.inputFrame()
    }
    
    open override func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? SingleLineTextInputRowModel {
            textField.text = m.argCollectionObj as? String
            currText = textField.text
            
            if let a = m.autoCorrection {
                textField.autocorrectionType = a ? .yes : .no
            }
            if let p = m.password {
                textField.isSecureTextEntry = p
            }
            if let c = m.capitalize {
                textField.autocapitalizationType = c ? .words: .none
            }
            
            var newCanSubmit = (m.originalCollectionObj as? String) != (m.argCollectionObj as? String)
            if let t = textField.text {
                newCanSubmit = newCanSubmit && isAcceptableLength(length: t.characters.count)
            }
            
            m.canSubmitArgs = (currText?.characters.count ?? 0) > 0
            self.baseRowViewDelegate?.submitArgsValidityChanged?(valid: m.canSubmitArgs)
            self.initializeWithText(text: textField.text)
        }
    }
    
    open override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        self.textField.setAllowResign()
        return self.textField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate Methods -
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        self.baseRowViewDelegate?.active(view: self)
    }
    open func textFieldDidChange(sender: NSNotification) {
        if currText != self.textField.text {
            currText = self.textField.text
            self.handleNewText(text: self.textField.text)
        }
    }
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !self.isAcceptableChars(str: string) {
            return false
        }
        let oldLength = textField.text?.characters.count ?? 0
        let newLength = oldLength + string.characters.count - range.length
        if !willOverflow(length: newLength) {
            self.handleNewTextLength(oldLength: oldLength, newLength: newLength)
            return true
        }
        return false
    }
    
    
}
