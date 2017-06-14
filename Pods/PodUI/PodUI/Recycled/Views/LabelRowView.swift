//
//  LabelRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/6/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

open class LabelRowView: BaseRowView {
    
    open var titleLabel = BaseUILabel(frame: CGRect.zero)
    open var subTitleLabel = BaseUILabel(frame: CGRect.zero)
    open var detailsLabel = BaseUILabel(frame: CGRect.zero)
    
    // MARK: - Lifecycle -
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(subTitleLabel)
        subTitleLabel.numberOfLines = 0
        self.contentView.addSubview(detailsLabel)
        detailsLabel.numberOfLines = 0
    }
    override open func frameUpdate() {
        super.frameUpdate()
        
        let titleMargins = (self.model as? LabelRowModel)?.titleMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        let availableTitleWidth = (self.rightEdge() - self.leftEdge()) - titleMargins.left - titleMargins.right
        let titleSize = titleLabel.sizeThatFits(CGSize(width: availableTitleWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let subTitleMargins = (self.model as? LabelRowModel)?.subTitleMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        let availableSubTitleWidth = (self.rightEdge() - self.leftEdge()) - subTitleMargins.left - subTitleMargins.right
        let subTitleSize = subTitleLabel.sizeThatFits(CGSize(width: availableSubTitleWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let detailsMargins = (self.model as? LabelRowModel)?.detailsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        
        let availableDetailsWidth = (self.rightEdge() - self.leftEdge()) - detailsMargins.left - detailsMargins.right
        let detailsSize = detailsLabel.sizeThatFits(CGSize(width: availableDetailsWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // Sizes are set
        titleLabel.frame.size = CGSize(width: availableTitleWidth, height: titleSize.height)
        subTitleLabel.frame.size = CGSize(width: availableSubTitleWidth, height: subTitleSize.height)
        detailsLabel.frame.size = CGSize(width: availableDetailsWidth, height: detailsSize.height)
        
        // Center Horizontally in parent
        titleLabel.frame.origin.x = self.leftEdge() + titleMargins.left
        subTitleLabel.frame.origin.x = self.leftEdge() + subTitleMargins.left
        detailsLabel.frame.origin.x = self.leftEdge() + detailsMargins.left
        
        let totalHeight = titleSize.height + titleMargins.bottom +
            subTitleSize.height + subTitleMargins.top +
            detailsSize.height + detailsMargins.top
        
        // Center Vertically in parent
        titleLabel.frame.origin.y = (self.contentView.frame.height - totalHeight) / 2
        subTitleLabel.frame.origin.y = titleLabel.frame.maxY + titleMargins.bottom + subTitleMargins.top
        detailsLabel.frame.origin.y = subTitleLabel.frame.maxY + subTitleMargins.bottom + detailsMargins.top
    }
    
    override open func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? LabelRowModel {
            titleLabel.numberOfLines = m.titleNumberOfLines
            titleLabel.labelInformation = m.title
            subTitleLabel.numberOfLines = m.subTitleNumberOfLines
            subTitleLabel.labelInformation = m.subTitle
            detailsLabel.numberOfLines = m.detailsNumberOfLines
            detailsLabel.labelInformation = m.details
        }
    }
    
    override open func containerTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: titleLabel)
        if  self.titleLabel.willConsumeLocationTap(location) ||
            self.subTitleLabel.willConsumeLocationTap(location) ||
            self.detailsLabel.willConsumeLocationTap(location) {
            return
        }
        super.containerTapped(sender)
    }
    
    open func leftEdge() -> CGFloat {
        return 0
    }
    open func rightEdge() -> CGFloat {
        return self.contentView.frame.width
    }
    
    open override func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        
        if let m = model as? LabelRowModel {
            titleLabel.labelInformation = m.title
            subTitleLabel.labelInformation = m.subTitle
            detailsLabel.labelInformation = m.details
        }
        
        let titleMargins = (model as? LabelRowModel)?.titleMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        let availableTitleWidth = w - titleMargins.left - titleMargins.right
        let titleLineHeight = titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).height
        var titleSize = titleLabel.sizeThatFits(CGSize(width: availableTitleWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let subTitleMargins = (model as? LabelRowModel)?.subTitleMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        let availableSubTitleWidth = w - subTitleMargins.left - subTitleMargins.right
        let subTitleLineHeight = subTitleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).height
        var subTitleSize = subTitleLabel.sizeThatFits(CGSize(width: availableSubTitleWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let detailsMargins = (model as? LabelRowModel)?.detailsMargins ?? Rect<CGFloat>(0, 0, 0, 0)
        let availableDetailsWidth = w - detailsMargins.left - detailsMargins.right
        let detailsLineHeight = detailsLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).height
        var detailsSize = detailsLabel.sizeThatFits(CGSize(width: availableDetailsWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if let m = model as? LabelRowModel {
            titleSize.height = m.titleNumberOfLines > 0 ? (titleLineHeight * CGFloat(m.titleNumberOfLines)) : titleSize.height
            subTitleSize.height = m.subTitleNumberOfLines > 0 ? (subTitleLineHeight * CGFloat(m.subTitleNumberOfLines)) : subTitleSize.height
            detailsSize.height = m.detailsNumberOfLines > 0 ? (detailsLineHeight * CGFloat(m.detailsNumberOfLines)) : detailsSize.height
        }
        
        var reqWidth: CGFloat = max(titleSize.width, max(subTitleSize.width, detailsSize.width))
        var reqHeight = (titleMargins.top + titleSize.height + titleMargins.bottom) +
                        (subTitleMargins.top + subTitleSize.height + subTitleMargins.bottom) +
                        (detailsMargins.top + detailsSize.height + detailsMargins.bottom)
        
        if model.width > 0 {
            reqWidth = reqWidth > model.height ? reqWidth : model.width
        } else if model.width == -1 {
            reqWidth = w
        }
        
        if model.height != 0 {
            reqHeight = reqHeight > model.height ? reqHeight : model.height
        }
        
        return CGSize(width: reqWidth, height: reqHeight)
        
    }
    
    override open func baseUILabelDelegateDidSet() {
        titleLabel.delegate = self.baseUILabelDelegate
        subTitleLabel.delegate = self.baseUILabelDelegate
        detailsLabel.delegate = self.baseUILabelDelegate
    }
    
}
