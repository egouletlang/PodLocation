//
//  BaseRowCVCell.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class BaseRowCVCell: UICollectionViewCell, BaseRowViewDelegate {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open class func build(id: String) -> BaseRowCVCell {
        if LabelRowModel.isLabelRowModel(id: id) {
            return LabelRowCVCell(frame: CGRect.zero)
        } else if GenericLabelRowModel.isGenericLabelRowModel(id: id) {
            return GenericLabelRowCVCell(frame: CGRect.zero)
        } else if ImageLabelRowModel.isImageLabelRowModel(id: id) {
            return ImageLabelRowCVCell(frame: CGRect.zero)
        } else if CardRowModel.isCardRowModel(id: id) {
            return CardRowCVCell(frame: CGRect.zero)
        } else if ImageRowModel.isImageRowModel(id: id) {
            return ImageRowCVCell(frame: CGRect.zero)
        } else if TileRowModel.isTileRowModel(id: id) {
            return TileRowCVCell(frame: CGRect.zero)
        }
        
        return BaseRowCVCell(frame: CGRect.zero)
    }
    
    open lazy var cell: BaseRowView = {
        self.createCell()
    }()
    open func createCell() -> BaseRowView {
        return BaseRowView(frame: CGRect.zero)
    }
    
    open func createLayout() {
        self.contentView.addSubview(cell)
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor(argb: 0xC3C3C3).cgColor
        cell.layer.borderWidth = 1
//        cell.layer.shadowColor = UIColor.black.cgColor;
//        cell.layer.shadowOffset = CGSize(width: 1, height: 5)
//        cell.layer.shadowOpacity = 0.2
        cell.baseRowViewDelegate = self
    }
    
    open func getSize(model: BaseRowModel, forWidth width: CGFloat) -> CGSize {
        let h = model.getContainerHeight()
        return CGSize(width: width, height: (h > 2) ? h : 2)
    }
    open func getDesiredSize(model: BaseRowModel, forWidth width: CGFloat) -> CGSize {
        let effWidth = width - model.padding.left - model.padding.right
        return CGSize(width: width - model.padding.left - model.padding.right, height: cell.getDesiredSize(model: model, forWidth: effWidth).height + model.padding.top - model.padding.bottom)
    }
    open func setData(model: BaseRowModel, forWidth width: CGFloat) {
        cell.setData(model: model)
        cell.frame.size = self.getSize(model: model, forWidth: width)
    }
    open func setFrame() {
        cell.frameUpdate()
    }
    
    open override func prepareForReuse() {
        cell.prepareForReuse()
    }
    
    open weak var baseRowCVCellDelegate: BaseRowCVCellDelegate?
    public func active(view: BaseRowView) {
        self.baseRowCVCellDelegate?.active(view: view)
    }
    public func tapped(model: BaseRowModel, view: BaseRowView) {
        self.baseRowCVCellDelegate?.tapped(model: model, view: view)
    }
    public func longPressed(model: BaseRowModel, view: BaseRowView) {
        self.baseRowCVCellDelegate?.longPressed(model: model, view: view)
    }
    public func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView) {
        self.baseRowCVCellDelegate?.swipe(swipe: swipe, model: model, view: view)
    }
    public func submitArgsValidityChanged(valid: Bool) {
        self.baseRowCVCellDelegate?.submitArgsValidityChanged(valid: valid)
    }
    public func submitArgsChanged() {
        self.baseRowCVCellDelegate?.submitArgsChanged()
    }
    
}
