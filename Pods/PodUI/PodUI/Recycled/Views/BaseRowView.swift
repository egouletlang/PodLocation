//
//  BaseRowView.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/23/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

private let DEFAULT_ACTIVE_BKG_COLOR = UIColor(rgb: 0xEEEEEE)
private let DEFAULT_INACTIVE_BKG_COLOR = UIColor(rgb: 0xFFFFFF)
private let DEFAULT_BORDER_COLOR = UIColor(rgb: 0x7B868C)

private let DELETE_CONTAINER_WIDTH: CGFloat = 80

open class BaseRowView: BaseUIView {
    
    //MARK: - Layout -
    //MARK: --------------------
    //MARK: | ---------------- |
    //MARK: | | Content View | |
    //MARK: | ---------------- |
    //MARK: --------------------
    //MARK: -
    
    //MARK: - UI -
    open let borders: [CALayer] = {
        var ret = [CALayer]()
        
        for i in 0 ..< 4 {
            ret.append(CALayer())
            ret[i].backgroundColor = DEFAULT_BORDER_COLOR.cgColor
        }
        
        return ret
    }()
    
    fileprivate class CustomTapGestureRecognizer: UITapGestureRecognizer {
        var index: Int!
    }
    
    /// Add subviews to this container, to help with recycling
    open var contentView = BaseUIView(frame: CGRect.zero)
    open var wrapper = BaseUIView(frame: CGRect.zero)
    open lazy var deleteContainers: [BaseUILabel] = {
        var labels = [BaseUILabel]()
        for var i in (0..<3) {
            let label = BaseUILabel(frame: CGRect.zero)
            
            let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(BaseRowView.containerTapped(_:)))
            tapGesture.index = i
            tapGesture.numberOfTapsRequired = 1
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGesture)
            labels.append(label)
        }
        return labels
    }()
    
    // MARK: - Lifecycle -
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        
        for deleteView in self.deleteContainers {
            self.addSubview(deleteView)
            deleteView.isHidden = true
        }
        
        self.addSubview(wrapper)
        
        wrapper.addSubview(contentView)
        contentView.clipsToBounds = true
        contentView.passThroughDefault = true
        
        for layer in borders {
            self.layer.addSublayer(layer)
        }
    }
    override open func addGestureRecognition() {
        super.addGestureRecognition()
        if handleGesturesAutomatically() {
            self.addTap(self, selector: #selector(BaseRowView.containerTapped(_:)))
            self.addLongPress(self, selector: "containerLongPressed")
        }
    }
    open func enableSwipe() {
        if self.shouldAddSwipeGestures() {
            let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(BaseRowView.swiped(_:)))
            swipeGesture.delegate = self
            self.addGestureRecognizer(swipeGesture)
        }
    }
    open func shouldAddSwipeGestures() -> Bool {
        return true
    }
    
    override open func frameUpdate() {
        super.frameUpdate()
        
        var offset: CGFloat = 1
        for deleteView in self.deleteContainers {
            deleteView.frame = CGRect(x: self.frame.width - (offset * DELETE_CONTAINER_WIDTH) - ((offset - 1) * 10),
                                        y: 0, width: DELETE_CONTAINER_WIDTH, height: self.frame.height)
            offset += 1
        }
        
        if let leftPadding = model?.borderPadding.left {
            self.borders[0].frame.size = CGSize(
                width: LayoutHelper.onePixel,
                height: self.frame.height - leftPadding.top - leftPadding.bottom)
            self.borders[0].frame.origin = CGPoint(x: leftPadding.left, y: leftPadding.top)
        }
        if let topPadding = model?.borderPadding.top {
            self.borders[1].frame.size = CGSize(
                width: self.frame.width - topPadding.left - topPadding.right,
                height: LayoutHelper.onePixel)
            self.borders[1].frame.origin = CGPoint(x: topPadding.left, y: topPadding.top)
        }
        if let rightPadding = model?.borderPadding.right {
            self.borders[2].frame.size = CGSize(
                width: LayoutHelper.onePixel,
                height: self.frame.height - rightPadding.top - rightPadding.bottom)
            self.borders[2].frame.origin = CGPoint(x: self.frame.width - rightPadding.right - LayoutHelper.onePixel, y: rightPadding.top)
        }
        if let bottomPadding = model?.borderPadding.bottom {
            self.borders[3].frame.size = CGSize(
                width: self.frame.width - bottomPadding.left - bottomPadding.right,
                height: LayoutHelper.onePixel)
            self.borders[3].frame.origin = CGPoint(x: bottomPadding.left, y: self.frame.height - bottomPadding.bottom - LayoutHelper.onePixel)
        }
        
        self.contentView.frame.size = self.getAvailableSize()
        self.contentView.frame.origin = self.getOffset()
        
        self.wrapper.frame = self.bounds
        
    }
    private func getAvailableSize() -> CGSize {
        if let m = model {
            return self.frame.insetBy(
                dx: (m.padding.left + m.padding.right) / 2,
                dy: (m.padding.top + m.padding.bottom) / 2).size
        }
        return self.frame.size
    }
    private func getOffset() -> CGPoint {
        if let m = model {
            return CGPoint(x: m.padding.left, y: m.padding.top)
        }
        return CGPoint.zero
    }
    
    // MARK: - Model -
    open weak var model: BaseRowModel?
    open func setData(model: BaseRowModel) {
        self.model = model
        
        self.wrapper.backgroundColor = model.backgroundColor ?? DEFAULT_INACTIVE_BKG_COLOR
        
        self.layer.cornerRadius = model.cornerRadius
        
        for layer in borders {
            layer.backgroundColor = model.borderColor?.cgColor ?? DEFAULT_BORDER_COLOR.cgColor
        }
        
        borders[0].isHidden = !model.borders.left
        borders[1].isHidden = !model.borders.top
        borders[2].isHidden = !model.borders.right
        borders[3].isHidden = !model.borders.bottom
        
        if let swipeModels = self.model?.swipeModels {
            maxSwipeX = CGFloat(swipeModels.count) * DELETE_CONTAINER_WIDTH +
                        CGFloat((swipeModels.count - 1) * 10)
            
            var i = 0
            while (i < 3) {
                if let m = swipeModels.get(i) {
                    deleteContainers.get(i)?.backgroundColor = m.color
                    deleteContainers.get(i)?.labelInformation = m.title
                    deleteContainers.get(i)?.isHidden = false
                } else {
                    deleteContainers.get(i)?.isHidden = true
                }
                i += 1
            }
            
        } else {
            maxSwipeX = 0
        }
        
        self.wrapper.frame.origin.x = self.getOffset().x
    }
    
    // MARK: - Delegate -
    open weak var baseRowViewDelegate: BaseRowViewDelegate?
    open func handleGesturesAutomatically() -> Bool {
        return true
    }
    
    open func containerTapped(_ sender: UITapGestureRecognizer) {
        self.baseRowViewDelegate?.active(view: self)
        if let m = self.model, m.clickResponse != nil {
            if let customTap = sender as? CustomTapGestureRecognizer {
                if let swipeModel = m.swipeModels.get(customTap.index) {
                    self.baseRowViewDelegate?.swipe(swipe: swipeModel, model: m, view: self)
                }
            } else {
                
                if self.wrapper.frame.origin.x == 0 {
                    self.baseRowViewDelegate?.tapped(model: m, view: self)
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.wrapper.frame.origin.x = 0
                    }
                }
                
            }
        }
    }
    open func containerLongPressed() {
        self.baseRowViewDelegate?.active(view: self)
        if let m = self.model, m.longPressResponse != nil {
            self.baseRowViewDelegate?.longPressed(model: m, view: self)
        }
    }
    
    // MARK: - Touch -
    open func tapped(location: CGPoint) -> Bool {
        return self.frame.contains(location)
    }
    open func longPressed(location: CGPoint) -> Bool {
        return self.frame.contains(location)
    }
    
    private var initialTransX: CGFloat = 0
    private var initialViewX: CGFloat = 0
    private var maxSwipeX: CGFloat = 0
    open func swiped(_ gesture: UIPanGestureRecognizer) {
        if self.model?.swipeModels.count ?? 0 == 0 { return }
        
        let translation = gesture.translation(in: self)
        if gesture.state == .began {
            initialTransX = translation.x
            initialViewX = self.wrapper.frame.origin.x
        } else if gesture.state == .changed {
            let translation = initialTransX - translation.x
            self.wrapper.frame.origin.x = initialViewX - translation
            
            if self.wrapper.frame.origin.x < -self.maxSwipeX {
                self.wrapper.frame.origin.x = -self.maxSwipeX
            } else if self.wrapper.frame.origin.x > 0 {
                self.wrapper.frame.origin.x = 0
            }
            
        } else if gesture.state == .ended {
            if self.wrapper.frame.origin.x < -maxSwipeX / 2 {
                UIView.animate(withDuration: 0.3) {
                    self.wrapper.frame.origin.x = -self.maxSwipeX
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.wrapper.frame.origin.x = 0
                }
            }
            
            
        }
    }
    
    // MARK: - Recycling -
    open func prepareForReuse() {}
    
    // MARK: - Sizing -
    /// This method returns the view's desired size given a width. Note the width
    /// returned maybe less than the width provided if the view doesn't "need" to
    /// be that wide.
    open func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        return CGSize(width: w, height: model.getContainerHeight())
    }
    
    
    open weak var baseUILabelDelegate: BaseUILabelDelegate? {
        didSet {
            self.baseUILabelDelegateDidSet()
        }
    }
    
    open func baseUILabelDelegateDidSet() {}
    
}
