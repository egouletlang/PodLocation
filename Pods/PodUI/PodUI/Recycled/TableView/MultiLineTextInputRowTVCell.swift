//
//  MultiLineTextInputRowTVCell.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/23/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class MultiLineTextInputRowTVCell: BaseRowTVCell {
    
    override open func createCell() -> BaseRowView {
        return MultiLineTextInputRowView(frame: CGRect.zero)
    }
    
    override open var canBecomeFocused: Bool {
        get {
            return true
        }
    }
    
    override open func becomeFirstResponder() -> Bool {
        return cell.becomeFirstResponder()
    }
    override open func resignFirstResponder() -> Bool {
        return cell.resignFirstResponder()
    }
    
}
