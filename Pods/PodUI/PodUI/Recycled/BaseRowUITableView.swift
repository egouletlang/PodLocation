//
//  BaseRowUITableView.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/23/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import BaseUtils

open class BaseRowUITableView: UITableView, UITableViewDataSource, UITableViewDelegate, BaseRowTVCellDelegate {
    
    open weak var customCellDelegate: CustomRowViewBuilderDelegate?
    
    open weak var baseRowUITableViewDelegate: BaseRowUITableViewDelegate?
    
    // MARK: - Initialization -
    public init() {
        super.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.__initialize()
    }
    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.__initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.__initialize()
    }
    
    private var modelCountBefore = 0
    
    deinit {
        cleanup()
        allModels.removeAll()
        filteredModels.removeAll()
    }
    
    private var initialized: Bool = false
    private func __initialize() {
        if !initialized {
            initialized = true
            modelCountBefore = BaseRowModel.currTracker()
            initialize()
        }
    }
    
    open func initialize() {
        dataSource = self
        delegate = self
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.allowsSelection = false
        self.backgroundColor = UIColor(rgb: 0xF8F8F8)
    }
    
    // MARK: - Responding to Frame Changes -
    fileprivate var currSize = CGSize.zero
    override open var frame: CGRect {
        didSet {
            self.frameDidSet()
        }
    }
    // only respond to frame updates if the size changes to avoid over-drawing.
    fileprivate func frameDidSet() {
        let heightChanged = self.currSize.height != self.frame.size.height
        let widthChanged = self.currSize.width != self.frame.size.height
        
        if self.currSize != self.frame.size {
            self.currSize = self.frame.size
            if widthChanged { self.frameWidthChanged() }
            if heightChanged { self.frameHeightChanged() }
            self.frameUpdate()
        }
    }
    
    open func frameWidthChanged() {
        for m in filteredModels {
            if m.measureHeight {
                let cell = BaseRowTVCell.build(id: m.getId(), width: self.frame.width, forMeasurement: true)
                m.height = cell.getDesiredSize(model: m, forWidth: self.frame.width).height
            }

        }
        for m in allModels {
            if m.measureHeight {
                let cell = BaseRowTVCell.build(id: m.getId(), width: self.frame.width, forMeasurement: true)
                m.height = cell.getDesiredSize(model: m, forWidth: self.frame.width).height
            }
            
        }
        self.reloadData()
    }
    open func frameHeightChanged() {}
    open func frameUpdate() {}
    
    
    // MARK: - Data -
    private var allModels = [BaseRowModel]()
    
    private var currSearch: String?
    private var currScope: String?
    private var filteredModels = [BaseRowModel]()
    open func getCount() -> Int {
        return filteredModels.count
    }
    open func getModel(index: Int) -> BaseRowModel? {
        if index < 0 || index >= filteredModels.count {
            return nil
        }
        return filteredModels[index]
    }
    func getOrBuildCell(tableView: BaseRowUITableView, model: BaseRowModel) -> BaseRowTVCell {
        let id = model.getId()
        let width = tableView.frame.width
        
        // attempt to dequeue
        if let cell = tableView.dequeueReusableCell(withIdentifier: BaseRowTVCell.buildReuseIdentifier(id: id, width: width)) as? BaseRowTVCell {
            return cell
        }
        
        // check for custom views
        let cell =  self.customCellDelegate?.getOrBuildCell(tableView: tableView, model: model) ??
                    BaseRowTVCell.build(id: model.getId(), width: width, forMeasurement: false)
        cell.cell.enableSwipe()
        cell.baseRowTVCellDelegate = self
        return cell
    }
    
    private func correctSizes(models: [BaseRowModel]) {
        for m in models {
            if m.height == 0 && m.measureHeight {
                let cell = BaseRowTVCell.build(id: m.getId(), width: self.frame.width, forMeasurement: true)
                m.height = cell.getDesiredSize(model: m, forWidth: self.frame.width).height
            }
        }
    }
    
    // MARK:
    open func reloadModels(models: [BaseRowModel], withAnimations: UITableViewRowAnimation? = nil) {
        let indexPaths = models.flatMap { (model: BaseRowModel) -> Int? in
            let index = self.filteredModels.index(of: model)
            return (index != NSNotFound) ? index : nil
            }.map { IndexPath(row: $0, section: 0) }
        
        if indexPaths.count <= 0 { return }
        
        let animations = withAnimations != nil ? withAnimations! : .none
        ThreadHelper.executeOnMainThread() {
            // No data to modify.
            
            // Replace data in table view
            if self.isIndexPathValid(indexPaths.last!) {
                if withAnimations == nil {
                    UIView.setAnimationsEnabled(false)
                }
                self.beginUpdates()
                self.reloadRows(at: indexPaths, with: animations)
                self.endUpdates()
                if withAnimations == nil {
                    UIView.setAnimationsEnabled(true)
                }
            } else {
                self.reloadData()
            }
        }
    }
    open func setModels(models: [BaseRowModel]) {
        self.correctSizes(models: models)
        ThreadHelper.checkedExecuteOnMainThread() {
            // Ensure we modify models and UI in the same thread
            self.allModels = models
            self.filter(scope: self.currScope, text: self.currSearch)
        }
    }
    open func appendModels(models: [BaseRowModel]) {
        self.correctSizes(models: models)
        ThreadHelper.checkedExecuteOnMainThread() {
            self.allModels.append(contentsOf: models)
            self.filter(scope: self.currScope, text: self.currSearch)
        }
    }
    open func replaceModel(model: BaseRowModel, newModels: [BaseRowModel], withAnimations: UITableViewRowAnimation? = nil) {
        self.correctSizes(models: newModels)
        if let index = self.allModels.index(of: model) {
            var indices = [Int]()
            for i in 0 ..< newModels.count {
                indices.append(index + i)
            }
            
            self.allModels.remove(at: index)
            for (index, model) in zip(indices, newModels) {
                self.allModels.insert(model, at: index)
            }
        }
        
        guard let index = self.filteredModels.index(of: model), index != NSNotFound else  {
            return
        }
        
        var indexPaths = [IndexPath]()
        var indices = [Int]()
        for i in 0 ..< newModels.count {
            indexPaths.append(IndexPath(row: index + i, section: 0))
            indices.append(index + i)
        }
        
        let animations = withAnimations != nil ? withAnimations! : .none
        ThreadHelper.executeOnMainThread() {
            // Replace data in models
            self.filteredModels.remove(at: index)
            for (index, model) in zip(indices, newModels) {
                self.filteredModels.insert(model, at: index)
            }
            
            // Replace data in table view
            let indexPath = IndexPath(row: index, section: 0)
            if self.isIndexPathValid(indexPath) {
                if withAnimations == nil {
                    UIView.setAnimationsEnabled(false)
                }
                self.beginUpdates()
                self.deleteRows(at: [indexPath], with: animations)
                self.insertRows(at: indexPaths, with: animations)
                self.endUpdates()
                if withAnimations == nil {
                    UIView.setAnimationsEnabled(true)
                }
            } else {
                self.reloadData()
            }
        }
    }
    
    open func insertModels(models: [BaseRowModel]) {
        self.correctSizes(models: models)
        ThreadHelper.checkedExecuteOnMainThread() {
            self.allModels.insert(contentsOf: models, at: 0)
            self.filter(scope: self.currScope, text: self.currSearch)
        }
    }
    
    override open func becomeFirstResponder() -> Bool {
        for cell in self.visibleCells {
            if cell.canBecomeFocused {
                return cell.becomeFirstResponder()
            }
        }
        return false
    }
    
    // MARK: - UITableViewDataSource Methods -
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let simpleTableView = tableView as? BaseRowUITableView {
            return simpleTableView.getCount()
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let genericTableView = tableView as? BaseRowUITableView {
            if let model = genericTableView.getModel(index: indexPath.row) {
                let cell = genericTableView.getOrBuildCell(tableView: genericTableView, model: model)
                cell.setData(model: model, forWidth: tableView.frame.width)
                cell.setFrame()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate Methods -
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let genericTableView = tableView as? BaseRowUITableView {
            if let model = genericTableView.getModel(index: indexPath.row) {
                return model.getContainerHeight()
            }
            
        }
        return 2
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let genericTableView = tableView as? BaseRowUITableView {
            if let model = genericTableView.getModel(index: indexPath.row) {
                return model.getContainerHeight()
            }
            
        }
        return 2
    }
    
    // MARK: - BaseRowTVCellDelegate -
    private weak var activeView: BaseRowView?
    public func active(view: BaseRowView) {
        self.activeView = view
    }
    public func tapped(model: BaseRowModel, view: BaseRowView) {
        self.baseRowUITableViewDelegate?.tapped(model: model, view: view)
    }
    public func longPressed(model: BaseRowModel, view: BaseRowView) {
        self.baseRowUITableViewDelegate?.longPressed(model: model, view: view)
    }
    public func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView) {
        self.baseRowUITableViewDelegate?.swipe(swipe: swipe, model: model, view: view)
    }
    public func collectArgs() -> [String: AnyObject] {
        var ret = [String: AnyObject]()
        
        for m in self.allModels {
            if m.canCollectArgs(),
               let k = m.argCollectionKey, let obj = m.argCollectionObj {
                ret[k] = obj
            }
        }
        
        return ret
    }
    public func submitArgsValidityChanged(valid: Bool) {
        checkSubmitArgs()
    }
    public func submitArgsChanged() {
        self.baseRowUITableViewDelegate?.submitArgsChanged?()
    }
    
    // MARK: - Protected helpers -
    open func checkSubmitArgs() {
        var anythingToSubmit = false
        var globalCanSubmit = true
        for m in self.allModels {
            if m.canCollectArgs() {
                anythingToSubmit = true
                globalCanSubmit = globalCanSubmit && m.canSubmitArgs
            }
        }
        
        print(anythingToSubmit)
        print(globalCanSubmit)
        if anythingToSubmit {
            self.baseRowUITableViewDelegate?.canCollectAndSubmitArgs?(set: globalCanSubmit)
        }
    }
    
    // MARK: - ScrollView Logic & Delegate -
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = otherGestureRecognizer as? UITapGestureRecognizer {
            return allowConcurrentTouchGestureRecognition
        }
        return allowMultipleGestureRecognition
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.baseRowUITableViewDelegate?.newScrollOffset?(offset: scrollView.contentOffset.y)
    }
    open var allowConcurrentTouchGestureRecognition = false
    open var allowMultipleGestureRecognition = true
    
    // MARK: - Clean up -
    // Hopefully the models are properly coded and this clean will be unnecessary.
    open func cleanup() {
        for model in self.allModels {
            model.cleanUp()
        }
        for model in self.filteredModels {
            model.cleanUp()
        }
    }
    
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
        self.reloadData()
    }
    
    // MARK: - Search For Models -
    open func getModelByTag(tag: String) -> BaseRowModel? {
        return (NSArray(array: self.allModels)
            .filtered(
                using: NSPredicate(format: "tag == %@", argumentArray: [tag])) as? [BaseRowModel])?.first
    }
}
