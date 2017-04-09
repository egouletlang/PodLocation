//
//  BaseUICollection.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/13/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import BaseUtils

private let CELL_FRACTION: CGFloat = 0.6
private let DEFAULT_INSETS = UIEdgeInsetsMake(7, 7, 7, 7)

open class BaseUICollection: BaseUIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BaseRowCVCellDelegate
{
    
    open weak var baseUICollectionDelegate: BaseUICollectionDelegate?
    
    open var collectionView: BaseUICollectionView!
    open var allModels = [BaseRowModel]()
    open var filteredModels = [BaseRowModel]()
    
    private var currScope: String?
    private var currSearch: String?
    
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.backgroundColor = getBackgroundColor()
        
        let layout = BaseUICollectionViewFlowLayout()
        layout.scrollDirection = getScrollDirection()
        layout.minimumLineSpacing = getLineSpacing()
        layout.minimumInteritemSpacing = getItemSpacing()
        collectionView = BaseUICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        for reg in self.getCellsToRegister() {
            collectionView.register(reg.0, forCellWithReuseIdentifier: reg.1)
        }
        
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
    
    //CONFIG
    open func getBackgroundColor() -> UIColor {
        return UIColor(argb: 0xF8F8F8)
    }
    open func getLineSpacing() -> CGFloat {
        return 10
    }
    open func getItemSpacing() -> CGFloat {
        return 10
    }
    open func getScrollDirection() -> UICollectionViewScrollDirection {
        return .vertical
    }
    open func getCellsToRegister() -> [(Swift.AnyClass?, String)] {
        return [
            (LabelRowCVCell.classForCoder(), LabelRowModel().getId()),
            (GenericLabelRowCVCell.classForCoder(), GenericLabelRowModel().getId()),
            (ImageLabelRowCVCell.classForCoder(), ImageLabelRowModel().getId()),
            (CardRowCVCell.classForCoder(), CardRowModel().getId()),
            (ImageRowCVCell.classForCoder(), ImageRowModel().getId()),
            (TileRowCVCell.classForCoder(), TileRowModel().getId()),
        ]
    }
    
    private func correctSizes(models: [BaseRowModel]) {
        for m in models {
            if CGSize.zero.equalTo(m.size) {
                let cell = BaseRowModel.build(id: m.getId(), forMeasurement: true)
                m.size = cell.getDesiredSize(model: m, forWidth: self.frame.width)
            }
        }
    }
    open func setModels(models: [BaseRowModel]) {
        self.correctSizes(models: models)
        ThreadHelper.checkedExecuteOnMainThread {
            self.allModels = models
            self.filter(scope: self.currScope, text: self.currSearch)
        }
    }
    
    open func createCollectionViewCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = filteredModels.get(indexPath.item),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.getId(), for: indexPath) as? BaseRowCVCell {
            
            cell.baseRowCVCellDelegate = self
            cell.setData(model: model, forWidth: model.size.width)
            cell.setFrame()
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredModels.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.createCollectionViewCell(collectionView, cellForItemAt: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let model = filteredModels.get(indexPath.item) {
            return model.size
        }
        
        return CGSize(width: 1, height: 1)
    }
    
    open func interceptTapped(model: BaseRowModel, view: BaseRowView) -> Bool {
        return false
    }
    
    public func active(view: BaseRowView) {}
    public func tapped(model: BaseRowModel, view: BaseRowView) {
        if !self.interceptTapped(model: model, view: view) {
            self.baseUICollectionDelegate?.tapped(model: model, view: view)
        }
    }
    public func longPressed(model: BaseRowModel, view: BaseRowView) {
        self.baseUICollectionDelegate?.longPressed(model: model, view: view)
    }
    public func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView) {
        self.baseUICollectionDelegate?.swipe(swipe: swipe, model: model, view: view)
    }
    public func submitArgsValidityChanged(valid: Bool) {}
    public func submitArgsChanged() {}
    
    
    open func filter(scope: String?, text: String?) {
        
        self.currScope = scope
        self.currSearch = text
        
        var result = self.allModels
        
        if let s = scope, s != "All" {
            let scopePredicate = NSPredicate(format: "((scope == %@) AND (scope != %@)) OR (scope == %@)",
                                             argumentArray: [s, BaseRowModel.NO_SCOPE, BaseRowModel.ANY_SCOPE])
            result = NSArray(array: result).filtered(using: scopePredicate) as! [BaseRowModel]
        }
        
        if let t = text, !t.isEmpty {
            let scopePredicate = NSPredicate(format: "((searchable == %@) AND (searchable != %@)) OR (searchable == %@)",
                                             argumentArray: [t, BaseRowModel.NO_QUERY, BaseRowModel.ANY_QUERY])
            result = NSArray(array: result).filtered(using: scopePredicate) as! [BaseRowModel]
        }
        
        self.filteredModels = result
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
    
}
