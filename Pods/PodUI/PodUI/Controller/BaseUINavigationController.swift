//
//  BaseUINavigationController.swift
//  BaseUtilityClasses
//
//  Created by Etienne Goulet-Lang on 11/20/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit

open class BaseUINavigationBar: UINavigationBar {
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}

open class BaseUINavigationController: UINavigationController {
    
    override public init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.__initialize()
    }
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.__initialize()
    }
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.__initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var initialized = false
    fileprivate func __initialize() {
        if !initialized {
            initialized = true
            initialize()
            
        }
    }
    
    fileprivate var currSize = CGSize.zero
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //Check if the frame has changed.. the old logic was broken anyway
        if self.currSize != view.frame.size {
            self.currSize = view.frame.size
            frameUpdate()
        }
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let views = self.getViews() {
            self.navigationBar.isTranslucent = true
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.backgroundColor = UIColor.clear
            self.navigationBar.tintColor = UIColor.white
            
            for view in views {
                self.view.insertSubview(view, at: 0)
            }
            
        } else if let bkgColor = self.getBackgroundColor() {
            self.navigationBar.backgroundColor = bkgColor
        }
        
        
        if let color = self.getTintColor() {
            self.navigationBar.tintColor = color
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]
        }
        
        createLayout()
    }
    
    open func getViews() -> [UIView]? {
        return nil
    }
    open func getBackgroundColor() -> UIColor? {
        return nil
    }
    open func getTintColor() -> UIColor? {
        return UIColor.white
    }
    
    open func initialize() {}
    open func createLayout() {}
    open func frameUpdate() {}
}
