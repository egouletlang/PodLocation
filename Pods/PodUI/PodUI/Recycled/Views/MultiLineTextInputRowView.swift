//
//  MultiLineTextInputRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/23/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class MultiLineTextInputRowView: BaseTextInputRowView, UITextViewDelegate {
    
    // MARK: - UI -
    private let textView = UITextView(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    open override func createAndAddSubviews() {
        super.createAndAddSubviews()
        
        self.contentView.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets.zero
        textView.backgroundColor = UIColor.clear
    }
    open override func frameUpdate() {
        super.frameUpdate()
        
        textView.frame = self.inputFrame()
        
    }
    open override func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? MultiLineTextInputRowModel {
            textView.text = m.argCollectionObj as? String
            
            if let autoCorrect = m.autoCorrection {
                textView.autocorrectionType = autoCorrect ? .yes : .no
            }
            
            var newCanSubmit = (m.originalCollectionObj as? String) != (m.argCollectionObj as? String)
            if let t = textView.text {
                newCanSubmit = newCanSubmit && isAcceptableLength(length: t.characters.count)
            }
            
            m.canSubmitArgs = newCanSubmit
            
            self.baseRowViewDelegate?.submitArgsValidityChanged?(valid: newCanSubmit)
            self.initializeWithText(text: textView.text)
        }
    }
    
    // MARK: - UITextViewDelegate Methods -
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !self.isAcceptableChars(str: text) {
            return false
        }
        
        let oldLength = textView.text?.characters.count ?? 0
        let newLength = oldLength + text.characters.count - range.length
        if !willOverflow(length: newLength) {
            self.handleNewTextLength(oldLength: oldLength, newLength: newLength)
            return true
        }
        return false
    }
    open func textViewDidChange(_ textView: UITextView) {
        self.handleNewText(text: textView.text)
    }
    
    open override func centerHintAndCharLimUIVertically() -> Bool {
        return false
    }
    
}
