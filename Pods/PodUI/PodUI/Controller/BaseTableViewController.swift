//
//  BaseTableViewController.swift
//  Dorado
//
//  Created by Etienne Goulet-Lang on 11/28/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import BaseUtils



open class BaseTableViewController: BaseUIViewController, BaseRowUITableViewDelegate, CustomRowViewBuilderDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    convenience public init(models: [BaseRowModel]) {
        self.init()
        self.initialModels = models
    }
    
    private var initialModels = [BaseRowModel]()
    
    public let tableView = BaseRowUITableView(frame: CGRect.zero)
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchMode = false
    
    override open func createLayout() {
        super.createLayout()
        
        self.view.addSubview(tableView)
        tableView.customCellDelegate = self
        tableView.baseRowUITableViewDelegate = self
        tableView.setModels(models: self.createModels())
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        
        if let scopes = self._getScopes() {
            searchController.searchBar.scopeButtonTitles = scopes
        }
        
        if addSearchBarHeader() {
            tableView.tableHeaderView = searchController.searchBar
            searchController.delegate = self
        }
    }
    
    override open func frameUpdate() {
        super.frameUpdate()
        
//        let top: CGFloat = searchMode ? -20 : self.effectiveTopLayoutGuide
        let top: CGFloat = self.effectiveTopLayoutGuide
        
        self.tableView.frame = CGRect(
            x: 0, y: top,
            width: self.view.bounds.width,
            height: self.effectiveBottomLayoutGuide - top)
    }
    
    open func createModels() -> [BaseRowModel] {
        return self.initialModels
    }
    
    open func getOrBuildCell(tableView: BaseRowUITableView, model: BaseRowModel) -> BaseRowTVCell? {
        return nil
    }
    
    open func tapped(model: BaseRowModel, view: BaseRowView) {}
    open func longPressed(model: BaseRowModel, view: BaseRowView) {}
    open func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView) {}
    
    public func willPresentSearchController(_ searchController: UISearchController) {
        searchMode = true
        ThreadHelper.delay(sec: 0.01, mainThread: true) {
            
            UIView.animate(withDuration: 0.29) {
                self.tableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        searchMode = true
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    // MARK: - Search Bar Delegate -
    open func updateSearchResults(for searchController: UISearchController) {
        let index = searchController.searchBar.selectedScopeButtonIndex
        filterContentForSearchText(scope: searchController.searchBar.scopeButtonTitles?[index], text: searchController.searchBar.text)
    }
    open func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(scope: searchBar.scopeButtonTitles?[selectedScope], text: searchBar.text)
    }
    open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.frameUpdate()
    }
    open func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.frameUpdate()
    }
    
    open func filterContentForSearchText(scope: String?, text: String?) {
        self.tableView.filter(scope: scope, text: text)
    }
    
    open func addSearchBarHeader() -> Bool {
        return false
    }
    
    private func _getScopes() -> [String]? {
        var scopes = self.getScopes()
        var addAll = true
        for s in scopes ?? [] {
            if s.lowercased() == "all" {
                addAll = false
            }
        }
        if addAll {
            scopes?.insert("All", at: 0)
        }
        return scopes
    }
    
    open func getScopes() -> [String]? {
        return nil
    }
    
}
