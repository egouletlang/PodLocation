//
//  GenericLabelRowModel.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 10/3/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

private let ID = "GenericLabelRowModel"
open class GenericLabelRowModel: LabelRowModel {
    
    open class func isGenericLabelRowModel(id: String) -> Bool {
        return id == ID
    }
    
    override open func getId() -> String {
        return ID
    }
    
    // MARK: - LHS View -
    open weak var lhsView: UIView?
    open var lhsSize = CGSize.zero
    open var lhsMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func with(lhsView v: UIView?) -> GenericLabelRowModel {
        self.set(lhsView: v)
        self.set(lhsSize: v?.frame.size ?? CGSize.zero)
        return self
    }
    open func with(lhsSize s: CGSize?) -> GenericLabelRowModel {
        self.set(lhsSize: s)
        return self
    }
    open func with(lhsMargins m: Rect<CGFloat>?) -> GenericLabelRowModel {
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
    
    open func with(rhsView v: UIView?) -> GenericLabelRowModel {
        self.set(rhsView: v)
        self.set(rhsSize: v?.frame.size ?? CGSize.zero)
        return self
    }
    open func with(rhsSize s: CGSize?) -> GenericLabelRowModel {
        self.set(rhsSize: s)
        return self
    }
    open func with(rhsMargins m: Rect<CGFloat>?) -> GenericLabelRowModel {
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
