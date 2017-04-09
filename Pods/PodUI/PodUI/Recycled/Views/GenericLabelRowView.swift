//
//  GenericLabelRowView.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 10/3/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

open class GenericLabelRowView: LabelRowView {
    
    private var lhsContainer = UIView(frame: CGRect.zero)
    private var rhsContainer = UIView(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.contentView.addSubview(lhsContainer)
        self.contentView.addSubview(rhsContainer)
    }
    override open func frameUpdate() {
        super.frameUpdate()
        
        let lhsSize = (self.model as? GenericLabelRowModel)?.lhsSize ?? CGSize.zero
        let lhsMargins = (self.model as? GenericLabelRowModel)?.lhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        let rhsSize = (self.model as? GenericLabelRowModel)?.rhsSize ?? CGSize.zero
        let rhsMargins = (self.model as? GenericLabelRowModel)?.rhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        // Set the sizes
        self.lhsContainer.frame.size = lhsSize
        (self.model as? GenericLabelRowModel)?.lhsView?.frame = self.lhsContainer.bounds
        self.rhsContainer.frame.size = rhsSize
        (self.model as? GenericLabelRowModel)?.rhsView?.frame = self.rhsContainer.bounds
        
        self.lhsContainer.frame.origin.x = lhsMargins.left
        self.rhsContainer.frame.origin.x = self.contentView.frame.width - rhsSize.width - rhsMargins.right
        
        self.lhsContainer.frame.origin.y = (self.contentView.frame.height - lhsSize.height) / 2
        self.rhsContainer.frame.origin.y = (self.contentView.frame.height - rhsSize.height) / 2
        
    }
    
    override open func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? GenericLabelRowModel {
            self.prepareForReuse()
            
            if let lhs = m.lhsView { self.lhsContainer.addSubview(lhs) }
            if let rhs = m.rhsView { self.rhsContainer.addSubview(rhs) }
        }
    }
    
    
    override open func leftEdge() -> CGFloat {
        let size = (self.model as? GenericLabelRowModel)?.lhsSize ?? CGSize.zero
        let margins = (self.model as? GenericLabelRowModel)?.lhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        return size.width + margins.left + margins.right
    }
    override open func rightEdge() -> CGFloat {
        let size = (self.model as? GenericLabelRowModel)?.rhsSize ?? CGSize.zero
        let margins = (self.model as? GenericLabelRowModel)?.rhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        return self.contentView.frame.width - (size.width + margins.left + margins.right)
    }
    
    override open func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        var lhsSize = (model as? GenericLabelRowModel)?.lhsSize ?? CGSize.zero
        let lhsMargins = (model as? GenericLabelRowModel)?.lhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        lhsSize = CGSize(width: lhsSize.width + lhsMargins.left + lhsMargins.right,
                         height: lhsSize.height + lhsMargins.top + lhsMargins.bottom)
        
        var rhsSize = (model as? GenericLabelRowModel)?.rhsSize ?? CGSize.zero
        let rhsMargins = (model as? GenericLabelRowModel)?.rhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        rhsSize = CGSize(width: rhsSize.width + rhsMargins.left + rhsMargins.right,
                         height: rhsSize.height + rhsMargins.top + rhsMargins.bottom)
        
        
        let labelSize = super.getDesiredSize(model: model, forWidth: w - lhsSize.width - rhsSize.width)
        
        return CGSize(width: labelSize.width + lhsSize.width + rhsSize.width,
                      height: max(max(labelSize.height, lhsSize.height), rhsSize.height))
    }
    
    // MARK: - Recycling -
    override open func prepareForReuse() {
        super.prepareForReuse()
        for view in self.lhsContainer.subviews {
            view.removeFromSuperview()
        }
        for view in self.rhsContainer.subviews {
            view.removeFromSuperview()
        }
    }
    
}
