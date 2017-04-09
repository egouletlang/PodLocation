//
//  AsynchronousRowView.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/24/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import BaseUtils

open class AsynchronousRowView: LabelRowView {
    
    // Don't instantiate UIActivityIndicatorView here as we've had crashes during its init when running on background thread
    private var activityIndicator = UIActivityIndicatorView(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        activityIndicator.hidesWhenStopped = true
        self.contentView.addSubview(activityIndicator)
    }
    
    override open func frameUpdate() {
        self.activityIndicator.sizeToFit()
        super.frameUpdate()
        
        let size = activityIndicator.frame.size
        let margins = (self.model as? AsynchronousRowModel)?.spinnerMargins ?? Rect<CGFloat>(0, 0, 0, 0)
            
        activityIndicator.frame.origin.x = margins.left
        activityIndicator.frame.origin.y = (self.contentView.frame.height - size.height) / 2

    }
    
    override open func setData(model: BaseRowModel) {
        if let m = model as? AsynchronousRowModel {
            activityIndicator.color = m.spinnerColor ?? UIColor.black
            
            if (m.state != .ACTIVE && m.shouldAutoStart) {
                m.title = m.activeLabel
                m.state = .ACTIVE
                activityIndicator.startAnimating()
                m.request(m, self)
            } else {
                switch (m.state) {
                case .INACTIVE:
                    m.title = m.inactiveLabel
                    activityIndicator.stopAnimating()
                case .ACTIVE:
                    m.title = m.activeLabel
                    activityIndicator.startAnimating()
                case .ERROR:
                    m.title = m.errorLabel
                    activityIndicator.stopAnimating()
                }
            }
            m.shouldAutoStart = false
        }
        super.setData(model: model)
    }
    override open func containerTapped(_ sender: UITapGestureRecognizer) {
        if let m = model as? AsynchronousRowModel {
            if m.state != .ACTIVE {
                m.shouldAutoStart = true
                setData(model: m)
            }
        }
    }
    
    open func showInactiveMessage() {
        ThreadHelper.checkedExecuteOnMainThread() {
            if let m = self.model as? AsynchronousRowModel {
                m.shouldAutoStart = false
                m.state = .INACTIVE
                self.setData(model: m)
            }
        }
        
    }
    open func showActiveMessage() {
        ThreadHelper.checkedExecuteOnMainThread() {
            if let m = self.model as? AsynchronousRowModel {
                m.shouldAutoStart = false
                m.state = .ACTIVE
                self.setData(model: m)
            }
        }
    }
    open func showErrorMessage() {
        ThreadHelper.checkedExecuteOnMainThread() {
            if let m = self.model as? AsynchronousRowModel {
                m.shouldAutoStart = false
                m.state = .ERROR
                self.setData(model: m)
            }
        }
    }
    
    override open func leftEdge() -> CGFloat {
        if let m = model as? AsynchronousRowModel {
            let size = activityIndicator.frame.size
            let margins = m.spinnerMargins
            if m.state == .ACTIVE {
                return size.width + margins.left + margins.right
            }
        }
        return super.leftEdge()
    }
    
    open override func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        var spinnerSize = activityIndicator.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let margins = (model as? AsynchronousRowModel)?.spinnerMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        spinnerSize = CGSize(width: spinnerSize.width + margins.left + margins.right,
                             height: spinnerSize.height + margins.top + margins.bottom)
        
        let labelSize = super.getDesiredSize(model: model, forWidth: w - spinnerSize.width)
        
        return CGSize(width: labelSize.width + spinnerSize.width,
                      height: max(labelSize.height, spinnerSize.height))
    }
}
