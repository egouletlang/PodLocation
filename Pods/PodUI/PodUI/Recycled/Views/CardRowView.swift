//
//  CardRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

private let BUTTON_HEIGHT: CGFloat = 30
private let BUTTON_SPACING: CGFloat = 8

private let MAX_BUTTON_COUNT = 3

open class CardRowView: BaseRowView {
    
    let imageView = BaseUIImageView(frame: CGRect.zero)
    let labelView = LabelRowView(frame: CGRect.zero)
    
    let buttonContainer = BaseUIView(frame: CGRect.zero)
    
    var buttons = [LabelRowView]()
    
    open override var baseRowViewDelegate: BaseRowViewDelegate? {
        didSet {
            for button in self.buttons {
                button.baseRowViewDelegate = self.baseRowViewDelegate
            }
        }
    }
    
    // MARK: - Lifecycle -
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(labelView)
        
        buttonContainer.passThroughDefault = true
        self.contentView.addSubview(buttonContainer)
        
        for _ in stride(from: 0, through: MAX_BUTTON_COUNT - 1, by: 1) {
            let button = LabelRowView(frame: CGRect.zero)
            button.layer.cornerRadius = 8
            self.buttonContainer.addSubview(button)
            buttons.append(button)
            button.baseRowViewDelegate = self.baseRowViewDelegate
        }
        
    }
    override open func frameUpdate() {
        super.frameUpdate()
        let cardImageHeight = (model as? CardRowModel)?.imageHeight ?? 0
        let cardImageMargins = (model as? CardRowModel)?.imageMargins ?? Rect<CGFloat>(0, 0, 0, 0)
            
        var labelSize = CGSize.zero
        if let m = self.model as? CardRowModel {
            labelSize = labelView.getDesiredSize(model: m, forWidth: self.contentView.bounds.width)
        }
        
        var buttonCount = (model as? CardRowModel)?.buttons.count ?? 0
        buttonCount = (buttonCount < MAX_BUTTON_COUNT ? buttonCount : MAX_BUTTON_COUNT)
        
        self.imageView.frame = CGRect(
            x: cardImageMargins.left,
            y: cardImageMargins.top,
            width: self.contentView.bounds.width - cardImageMargins.left - cardImageMargins.right,
            height: cardImageHeight)
        self.labelView.frame = CGRect(
            x: 0,
            y: self.imageView.frame.maxY + cardImageMargins.bottom,
            width: self.contentView.bounds.width,
            height: labelSize.height)
        self.buttonContainer.frame = CGRect(
            x: 10,
            y: self.labelView.frame.maxY,
            width: self.contentView.bounds.width - 20,
            height: CGFloat(buttonCount) * BUTTON_HEIGHT + CGFloat(buttonCount + 1) * BUTTON_SPACING)
            
        var currentOffset = BUTTON_SPACING
        for button in buttons {
            button.frame = CGRect(
                x: 0,
                y: currentOffset,
                width: self.buttonContainer.bounds.width,
                height: BUTTON_HEIGHT)
            currentOffset += BUTTON_HEIGHT + BUTTON_SPACING
        }
        
        
    }
    
    override open func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? CardRowModel {
            self.imageView.load(str: m.imageUrl)
            
            labelView.titleLabel.numberOfLines = m.titleNumberOfLines
            labelView.titleLabel.labelInformation = m.title
            labelView.subTitleLabel.numberOfLines = m.subTitleNumberOfLines
            labelView.subTitleLabel.labelInformation = m.subTitle
            labelView.detailsLabel.numberOfLines = m.detailsNumberOfLines
            labelView.detailsLabel.labelInformation = m.details
            
            for (model, view) in zip(m.buttons, self.buttons) {
                view.setData(model: model)
                print(view.frame)
            }
        }
    }
    
    override open func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        
        let labelSize = labelView.getDesiredSize(model: model, forWidth: w)
        let cardImageHeight = (model as? CardRowModel)?.imageHeight ?? 0
        let cardImageMargins = (model as? CardRowModel)?.imageMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        var buttonCount = (model as? CardRowModel)?.buttons.count ?? 0
        buttonCount = (buttonCount < MAX_BUTTON_COUNT ? buttonCount : MAX_BUTTON_COUNT)
        
        return CGSize(width: w,
                      height: labelSize.height + cardImageHeight + cardImageMargins.top + cardImageMargins.bottom +
                                CGFloat(buttonCount) * BUTTON_HEIGHT + CGFloat(buttonCount + 1) * BUTTON_SPACING)
        
    }
    
}
