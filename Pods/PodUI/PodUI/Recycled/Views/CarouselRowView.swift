//
//  CarouselRowView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import BaseUtils

private let CELL_FRACTION: CGFloat = 0.6
private let DEFAULT_INSETS = UIEdgeInsetsMake(7, 7, 7, 7)

open class CarouselRowView: BaseRowView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,  BaseRowCVCellDelegate
{
    
    override open func handleGesturesAutomatically() -> Bool {
        return false
    }
    
    private var collectionView: BaseUICollectionView!
    private var models = [BaseRowModel]()
    
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.backgroundColor = UIColor(argb: 0xAAAAAA)
        
        let layout = BaseUICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView = BaseUICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.register(LabelRowCVCell.classForCoder(), forCellWithReuseIdentifier: LabelRowModel().getId())
        collectionView.register(GenericLabelRowCVCell.classForCoder(), forCellWithReuseIdentifier: GenericLabelRowModel().getId())
        collectionView.register(ImageLabelRowCVCell.classForCoder(), forCellWithReuseIdentifier: ImageLabelRowModel().getId())
        collectionView.register(CardRowCVCell.classForCoder(), forCellWithReuseIdentifier: CardRowModel().getId())
        collectionView.register(ImageRowCVCell.classForCoder(), forCellWithReuseIdentifier: ImageRowModel().getId())
        collectionView.register(TileRowCVCell.classForCoder(), forCellWithReuseIdentifier: TileRowModel().getId())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let contentInsets = DEFAULT_INSETS
        self.collectionView?.contentInset = contentInsets
        
        self.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
    }
    override open func frameUpdate() {
        super.frameUpdate()
        self.collectionView.frame = self.bounds
        collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }
    
    private func correctSizes(models: [BaseRowModel]) {
        for m in models {
            if m.height == 0 && m.measureHeight {
                let cell = BaseRowCVCell.build(id: m.getId())
                m.height = cell.getDesiredSize(model: m, forWidth: self.frame.width).height
                print(m.height)
            }
        }
    }
    
    open override func setData(model: BaseRowModel) {
        super.setData(model: model)
        if let m = model as? CarouselRowModel {
            self.setModels(models: m.elements)
        }
    }
    
    open override func shouldAddSwipeGestures() -> Bool {
        return false
    }
    
    open func setModels(models: [BaseRowModel]) {
        let crm = CarouselRowModel()
        let filterModels = models.flatMap { ($0.getId() == crm.getId()) ? nil : $0 }
        
        self.correctSizes(models: filterModels)
        ThreadHelper.checkedExecuteOnMainThread {
            self.models = filterModels
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }
    
    open func getCellWidth() -> CGFloat {
        let bounds = UIScreen.main.bounds
        return CELL_FRACTION * (bounds.width > bounds.height ? bounds.height : bounds.width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let model = models.get(indexPath.item),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.getId(), for: indexPath) as? BaseRowCVCell {
            
            cell.baseRowCVCellDelegate = self
            cell.setData(model: model, forWidth: model.size.width != 0 ? model.size.width : self.getCellWidth())
            cell.setFrame()
        
            return cell
        }
        return UICollectionViewCell()
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let model = models.get(indexPath.item) {
            return CGSize(width: model.size.width != 0 ? model.size.width : self.getCellWidth(),
                          height: self.frame.height - DEFAULT_INSETS.top - DEFAULT_INSETS.bottom)
        }
        return CGSize(width: 10, height: 10)
    }
    
    public func active(view: BaseRowView) {
        self.baseRowViewDelegate?.active(view: self)
    }
    public func tapped(model: BaseRowModel, view: BaseRowView) {
        self.baseRowViewDelegate?.tapped(model: model, view: view)
    }
    public func longPressed(model: BaseRowModel, view: BaseRowView) {
        self.baseRowViewDelegate?.longPressed(model: model, view: view)
    }
    public func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView) {}
    public func submitArgsValidityChanged(valid: Bool) {
        self.baseRowViewDelegate?.submitArgsValidityChanged?(valid: valid)
    }
    public func submitArgsChanged() {
        self.baseRowViewDelegate?.submitArgsChanged?()
    }
    
    override open func getDesiredSize(model: BaseRowModel, forWidth w: CGFloat) -> CGSize {
        let crm = CarouselRowModel()
        var reqHeight: CGFloat = 2
        var currHeight: CGFloat = 0
        
        let cellWidth = self.getCellWidth()
        
        for element in (model as? CarouselRowModel)?.elements ?? [] {
            if (element.getId() == crm.getId()) { continue }
            let cell = BaseRowCVCell.build(id: element.getId())
            currHeight = cell.getDesiredSize(model: element, forWidth: cellWidth).height
            reqHeight = (reqHeight > currHeight) ? reqHeight : currHeight
        }
        
        return CGSize(width: w,
                      height: reqHeight + DEFAULT_INSETS.top + DEFAULT_INSETS.bottom + 20)
        
    }
    
    
    
}
