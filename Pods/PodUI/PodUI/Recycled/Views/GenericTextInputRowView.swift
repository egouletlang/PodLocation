//
//  GenericTextInputRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 3/23/17.
//  Copyright © 2017 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

open class GenericTextInputRowView: SingleLineTextInputRowView {
    
    private var lhsContainer = UIView(frame: CGRect.zero)
    private var rhsContainer = UIView(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    open override func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.contentView.addSubview(lhsContainer)
        self.contentView.addSubview(rhsContainer)
    }
    open override func frameUpdate() {
        super.frameUpdate()
        
        let lhsSize = (self.model as? GenericTextInputRowModel)?.lhsSize ?? CGSize.zero
        let lhsMargins = (self.model as? GenericTextInputRowModel)?.lhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        let rhsSize = (self.model as? GenericTextInputRowModel)?.rhsSize ?? CGSize.zero
        let rhsMargins = (self.model as? GenericTextInputRowModel)?.rhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        // Set the sizes
        self.lhsContainer.frame.size = lhsSize
        (self.model as? GenericTextInputRowModel)?.lhsView?.frame = self.lhsContainer.bounds
        self.rhsContainer.frame.size = rhsSize
        (self.model as? GenericTextInputRowModel)?.rhsView?.frame = self.rhsContainer.bounds
        
        self.lhsContainer.frame.origin.x = lhsMargins.left
        self.rhsContainer.frame.origin.x = self.contentView.frame.width - rhsSize.width - rhsMargins.right
        
        self.lhsContainer.frame.origin.y = (self.contentView.frame.height - lhsSize.height) / 2
        self.rhsContainer.frame.origin.y = (self.contentView.frame.height - rhsSize.height) / 2
        
    }
    
    open override func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? GenericTextInputRowModel {
            self.prepareForReuse()
            
            if let lhs = m.lhsView { self.lhsContainer.addSubview(lhs) }
            if let rhs = m.rhsView { self.rhsContainer.addSubview(rhs) }
        }
    }
    
    
    open override func leftEdge() -> CGFloat {
        let size = (self.model as? GenericTextInputRowModel)?.lhsSize ?? CGSize.zero
        let margins = (self.model as? GenericTextInputRowModel)?.lhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        return size.width + margins.left + margins.right
    }
    open override func rightEdge() -> CGFloat {
        let size = (self.model as? GenericTextInputRowModel)?.rhsSize ?? CGSize.zero
        let margins = (self.model as? GenericTextInputRowModel)?.rhsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        return self.contentView.frame.width - (size.width + margins.left + margins.right)
    }
    
    // MARK: - Recycling -
    open override func prepareForReuse() {
        super.prepareForReuse()
        for view in self.lhsContainer.subviews {
            view.removeFromSuperview()
        }
        for view in self.rhsContainer.subviews {
            view.removeFromSuperview()
        }
    }
    
}
