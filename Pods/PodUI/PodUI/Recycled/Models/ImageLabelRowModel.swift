//
//  ImageLabelRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

private let ID = "ImageLabelRowModel"
open class ImageLabelRowModel: LabelRowModel {
    
    open class func isImageLabelRowModel(id: String) -> Bool {
        return id == ID
    }
    
    override open func getId() -> String {
        return ID
    }
    
    open var lhsCircle = false
    open func with(lhsCircle: Bool) -> ImageLabelRowModel {
        self.set(lhsCircle: lhsCircle)
        return self
    }
    open func set(lhsCircle: Bool) {
        self.lhsCircle = lhsCircle
    }
    
    // MARK: - LHS View -
    open var lhsImage: UIImage?
    open var lhsImageStr: String?
    open var lhsSize = CGSize.zero
    open var lhsMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withImage(_ i: UIImage?) -> ImageLabelRowModel {
        self.setImage(i)
        return self
    }
    open func with(lhsImage i: String?) -> ImageLabelRowModel {
        self.set(lhsImage: i)
        return self
    }
    open func with(lhsSize s: CGSize?) -> ImageLabelRowModel {
        self.set(lhsSize: s)
        return self
    }
    open func with(lhsMargins m: Rect<CGFloat>?) -> ImageLabelRowModel {
        self.set(lhsMargins: m)
        return self
    }
    
    open func setImage(_ i: UIImage?) {
        self.lhsImage = i
        if i != nil {
            self.lhsSize = CGSize(width: 50, height: 50)
            self.lhsMargins.right = 10
        } else {
            self.lhsSize = CGSize.zero
            self.lhsMargins.right = 0
        }
    }
    open func set(lhsImage i: String?) {
        self.lhsImageStr = i
        if i != nil {
            self.lhsSize = CGSize(width: 50, height: 50)
            self.lhsMargins.right = 10
        } else {
            self.lhsSize = CGSize.zero
            self.lhsMargins.right = 0
        }
    }
    open func set(lhsSize s: CGSize?) {
        self.lhsSize = s ?? CGSize.zero
    }
    open func set(lhsMargins m: Rect<CGFloat>?) {
        self.lhsMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    // MARK: - RHS View -
    open var rhsImage: String?
    open var rhsSize = CGSize.zero
    open var rhsMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func with(rhsImage i: String?) -> ImageLabelRowModel {
        self.set(rhsImage: i)
        return self
    }
    open func with(rhsSize s: CGSize?) -> ImageLabelRowModel {
        self.set(rhsSize: s)
        return self
    }
    open func with(rhsMargins m: Rect<CGFloat>?) -> ImageLabelRowModel {
        self.set(rhsMargins: m)
        return self
    }
    
    open func set(rhsImage i: String?) {
        self.rhsImage = i
        if i != nil {
            self.rhsSize = CGSize(width: 50, height: 50)
            self.rhsMargins.left = 10
        } else {
            self.rhsSize = CGSize.zero
            self.rhsMargins.left = 0
        }
    }
    open func set(rhsSize s: CGSize?) {
        self.rhsSize = s ?? CGSize.zero
    }
    open func set(rhsMargins m: Rect<CGFloat>?) {
        self.rhsMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
}
