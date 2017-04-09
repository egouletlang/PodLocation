//
//  ImageLabelRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

open class ImageLabelRowView: LabelRowView {
    
    private var lhsImageView = BaseUIImageView(frame: CGRect.zero)
    private var rhsImageView = BaseUIImageView(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    override open func createAndAddSubviews() {
        self.contentView.addSubview(lhsImageView)
        self.contentView.addSubview(rhsImageView)
        super.createAndAddSubviews()
    }
    override open func frameUpdate() {
        super.frameUpdate()
        
        var lhsSize = (self.model as? ImageLabelRowModel)?.lhsSize ?? CGSize.zero
        let lhsMargins = (self.model as? ImageLabelRowModel)?.lhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        let rhsSize = (self.model as? ImageLabelRowModel)?.rhsSize ?? CGSize.zero
        let rhsMargins = (self.model as? ImageLabelRowModel)?.rhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        if let m = (self.model as? ImageLabelRowModel), m.lhsCircle {
            lhsSize.width -= 4
            lhsSize.height -= 4
            self.lhsImageView.layer.cornerRadius = lhsSize.width / 2
        }
        
        // Set the sizes
        self.lhsImageView.frame.size = lhsSize
        self.rhsImageView.frame.size = rhsSize
        
        self.lhsImageView.frame.origin.x = lhsMargins.left
        if let m = (self.model as? ImageLabelRowModel), m.lhsCircle {
            self.lhsImageView.frame.origin.x += 2
        }
        
        self.rhsImageView.frame.origin.x = self.contentView.frame.width - rhsSize.width + rhsMargins.left
        
        self.lhsImageView.frame.origin.y = lhsMargins.top
        if let m = (self.model as? ImageLabelRowModel), m.lhsCircle {
            self.lhsImageView.frame.origin.y += 2
        }
        self.rhsImageView.frame.origin.y = lhsMargins.bottom
        
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        lhsImageView.clear()
        rhsImageView.clear()
    }
    
    override open func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? ImageLabelRowModel {
            
            if let image = m.lhsImage {
                self.lhsImageView.load(img: image)
            } else {
                self.lhsImageView.load(str: m.lhsImageStr)
            }
            
            self.rhsImageView.load(str: m.rhsImage)
        }
    }
    
    override open func leftEdge() -> CGFloat {
        let size = (self.model as? ImageLabelRowModel)?.lhsSize ?? CGSize.zero
        let margins = (self.model as? ImageLabelRowModel)?.lhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        return size.width + margins.left + margins.right
    }
    override open func rightEdge() -> CGFloat {
        let size = (self.model as? ImageLabelRowModel)?.rhsSize ?? CGSize.zero
        let margins = (self.model as? ImageLabelRowModel)?.rhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        return self.contentView.frame.width - (size.width + margins.left + margins.right)
    }
    
    override open func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        var lhsSize = (model as? ImageLabelRowModel)?.lhsSize ?? CGSize.zero
        let lhsMargins = (model as? ImageLabelRowModel)?.lhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        lhsSize = CGSize(width: lhsSize.width + lhsMargins.left + lhsMargins.right,
                         height: lhsSize.height + lhsMargins.top + lhsMargins.bottom)
        
        var rhsSize = (model as? ImageLabelRowModel)?.rhsSize ?? CGSize.zero
        let rhsMargins = (model as? ImageLabelRowModel)?.rhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        rhsSize = CGSize(width: rhsSize.width + rhsMargins.left + rhsMargins.right,
                         height: rhsSize.height + rhsMargins.top + rhsMargins.bottom)
        
        let labelSize = super.getDesiredSize(model: model, forWidth: w - lhsSize.width - rhsSize.width)
        
        return CGSize(width: labelSize.width + lhsSize.width + rhsSize.width,
                      height: max(max(labelSize.height, lhsSize.height), rhsSize.height))
    }
    
}
