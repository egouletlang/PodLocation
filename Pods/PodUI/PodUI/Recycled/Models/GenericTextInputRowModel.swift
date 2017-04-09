//
//  GenericTextInputRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/23/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

private let ID = "GenericTextInputRowModel"
open class GenericTextInputRowModel: SingleLineTextInputRowModel {
    
    open class func isGenericTextInputRowModel(id: String) -> Bool {
        return id == ID
    }
    
    open override func getId() -> String {
        return ID
    }
    
    // MARK: - LHS View -
    open weak var lhsView: UIView?
    open var lhsSize = CGSize.zero
    open var lhsMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func with(lhsView v: UIView?) -> GenericTextInputRowModel {
        self.set(lhsView: v)
        self.set(lhsSize: v?.frame.size ?? CGSize.zero)
        return self
    }
    open func with(lhsSize s: CGSize?) -> GenericTextInputRowModel {
        self.set(lhsSize: s)
        return self
    }
    open func with(lhsMargins m: Rect<CGFloat>?) -> GenericTextInputRowModel {
        self.set(lhsMargins: m)
        return self
    }
    
    open func set(lhsView v: UIView?) {
        self.lhsView = v
    }
    open func set(lhsSize s: CGSize?) {
        self.lhsSize = s ?? CGSize.zero
    }
    open func set(lhsMargins m: Rect<CGFloat>?) {
        self.lhsMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    // MARK: - RHS View -
    open weak var rhsView: UIView?
    open var rhsSize = CGSize.zero
    open var rhsMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func with(rhsView v: UIView?) -> GenericTextInputRowModel {
        self.set(rhsView: v)
        self.set(rhsSize: v?.frame.size ?? CGSize.zero)
        return self
    }
    open func with(rhsSize s: CGSize?) -> GenericTextInputRowModel {
        self.set(rhsSize: s)
        return self
    }
    open func with(rhsMargins m: Rect<CGFloat>?) -> GenericTextInputRowModel {
        self.set(rhsMargins: m)
        return self
    }
    
    open func set(rhsView v: UIView?) {
        self.rhsView = v
    }
    open func set(rhsSize s: CGSize?) {
        self.rhsSize = s ?? CGSize.zero
    }
    open func set(rhsMargins m: Rect<CGFloat>?) {
        self.rhsMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
}
