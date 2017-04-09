//
//  BaseCollectionViewController.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/13/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import BaseUtils



open class BaseCollectionViewController: BaseUIViewController, BaseUICollectionDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    public let collectionView = BaseUICollection(frame: CGRect.zero)
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchMode = false
    
    override open func createLayout() {
        super.createLayout()
        
        self.view.addSubview(collectionView)
        collectionView.baseUICollectionDelegate = self
        collectionView.setModels(models: self.createModels())
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        
        if let scopes = self._getScopes() {
            searchController.searchBar.scopeButtonTitles = scopes
        }
        
        if addSearchBarHeader() {
            
            collectionView.collectionView.contentInset = UIEdgeInsetsMake(searchController.searchBar.frame.height, 0, 0, 0)
            collectionView.collectionView.addSubview(searchController.searchBar)
            searchController.delegate = self
        }
    }
    
    override open func frameUpdate() {
        super.frameUpdate()
        
        //        let top: CGFloat = searchMode ? -20 : self.effectiveTopLayoutGuide
        let top: CGFloat = self.effectiveTopLayoutGuide
        
        self.collectionView.frame = CGRect(
            x: 0, y: top,
            width: self.view.bounds.width,
            height: self.effectiveBottomLayoutGuide - top)
    }
    
    open func createModels() -> [BaseRowModel] {
        return []
    }
    
    open func tapped(model: BaseRowModel, view: BaseRowView) {}
    open func longPressed(model: BaseRowModel, view: BaseRowView) {}
    open func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView) {}
    
    public func willPresentSearchController(_ searchController: UISearchController) {
        searchMode = true
        ThreadHelper.delay(sec: 0.01, mainThread: true) {
            
            UIView.animate(withDuration: 0.29) {
                self.collectionView.collectionView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        searchMode = true
        UIView.animate(withDuration: 0.3) {
            self.collectionView.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    // MARK: - Search Bar Delegate -
    public func updateSearchResults(for searchController: UISearchController) {
        let index = searchController.searchBar.selectedScopeButtonIndex
        filterContentForSearchText(scope: searchController.searchBar.scopeButtonTitles?[index], text: searchController.searchBar.text)
    }
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(scope: searchBar.scopeButtonTitles?[selectedScope], text: searchBar.text)
    }
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.frameUpdate()
    }
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.frameUpdate()
    }
    
    open func filterContentForSearchText(scope: String?, text: String?) {
        self.collectionView.filter(scope: scope, text: text)
    }
    
    open func addSearchBarHeader() -> Bool {
        return true
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
