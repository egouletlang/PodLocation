//
//  BaseUITabBarController.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/10/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit

open class BaseUITabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - Constructor -
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.__initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.__initialize()
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.__initialize()
    }
    
    private var baseInitialized = false
    private func __initialize() {
        if !baseInitialized {
            baseInitialized = true
            initialize()
        }
    }
    
    // MARK: - Layout Information -
    private var currSize = CGSize.zero
    
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //Check if the frame has changed.. the old logic was broken anyway
        if self.currSize != view.frame.size {
            self.currSize = view.frame.size
            
            // This is needed to support autolayout.  Whenever the frame is updated, a request
            // to update the constraints will also be generated, which will in turn call
            // updateViewConstraints(...)
            self.view.setNeedsUpdateConstraints()
            frameUpdate()
        }
    }
    
    
    open func initialize() {}
    open func createLayout() {}
    open func frameUpdate() {}
    open func getTintColor() -> UIColor {
        return UIColor(argb: 0xA0A0A0)
    }
    open func getInactiveColor() -> UIColor {
        return UIColor(rgb: 0x7B868C)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = false
        self.delegate = self
        
        self.tabBar.barStyle = UIBarStyle.default
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = self.getTintColor()
        self.tabBar.unselectedItemTintColor = self.getInactiveColor()
        createLayout()
    }
    
    
    
    
    private func resizeImage(imageName: String) -> UIImage? {
        let image = UIImage(named: imageName)!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 25, height: 25), false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret;
    }
    
    open func createTabItem(title: String) -> UITabBarItem {
        let tab = UITabBarItem()
        tab.title = title
        tab.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName: self.getInactiveColor()
            ], for: UIControlState.normal)
        tab.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName: self.getTintColor()
            ], for: UIControlState.selected)
        tab.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        return tab
    }
    
    open func createTabItem(title: String, active: String, inactive: String) -> UITabBarItem {
        let tab = UITabBarItem()
        tab.title = title
        tab.image = UIImage(named: inactive)
        tab.selectedImage = UIImage(named: active)
        tab.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 10),
            NSForegroundColorAttributeName: self.getInactiveColor()
            ], for: UIControlState.normal)
        tab.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 10),
            NSForegroundColorAttributeName: self.getTintColor()
            ], for: UIControlState.selected)
        tab.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        return tab
    }
    
    
}
