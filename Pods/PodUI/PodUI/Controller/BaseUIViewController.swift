//
//  BaseUIViewController.swift
//  BaseUtilityClasses
//
//  Created by Etienne Goulet-Lang on 11/20/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit
import BaseUtils

open class BaseUIViewController: UIViewController, BaseUIViewDelegate {
    
    open static var StatusBarHeight: CGFloat = 20
    open static var NavBarHeight: CGFloat = 44
    
    //MARK: - Constructor -
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.__initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.__initialize()
    }
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.__initialize()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configuration -
    fileprivate var initialized = false
    fileprivate func __initialize() {
        if !initialized {
            initialized = true
            initialize()
        }
    }
    
    // MARK: - Layout Information -
    fileprivate var currSize = CGSize.zero
    fileprivate var topLayout: CGFloat = 0
    open var navBarHeight: CGFloat {
        get { return BaseUIViewController.NavBarHeight }
    }
    open var statusBarHeight: CGFloat {
        get { return BaseUIViewController.StatusBarHeight }
    }
    open var effectiveTopLayoutGuide: CGFloat {
        get {
            return (self.navigationController != nil) ? (navBarHeight + statusBarHeight) : 0
        }
    }
    open var effectiveBottomLayoutGuide: CGFloat {
        get {
            let diff = UIScreen.main.bounds.height - self.view.frame.height
            return self.view.frame.height - keyboardHeight + (keyboardHeight == 0 ? 0 : diff)
        }
    }
    open var isPortraitMode: Bool {
        get {
#if MAIN
            let orientation = UIApplication.shared.statusBarOrientation
            return (orientation == .portrait || orientation == .portraitUpsideDown)
#else
            return true
#endif
            // Don't use UIDevice.currentDevice().orientation as that seems to sometimes be wrong ?!
            
        }
    }
    
    // MARK: - State -
    fileprivate var hasAppearedBefore = false
    var layoutCreated = false
    
    // MARK: - Lifecycle -
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //Check if the frame has changed.. the old logic was broken anyway
        if self.currSize != view.frame.size || topLayout != effectiveTopLayoutGuide {
            self.currSize = view.frame.size
            self.topLayout = effectiveTopLayoutGuide
            
            // This is needed to support autolayout.  Whenever the frame is updated, a request
            // to update the constraints will also be generated, which will in turn call
            // updateViewConstraints(...)
            self.view.setNeedsUpdateConstraints()
            frameUpdate()
        }
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        if !layoutCreated {
            self.automaticallyAdjustsScrollViewInsets = false
            self.view.backgroundColor = defaultBackgroundColor()
            if addDismissButton() && (self.navigationController?.viewControllers.count == 1) {
                self.setNavigationItem(text: self.dismissButtonCopy(), target: self, selector: #selector(BaseUIViewController.dismissVC), left: true)
            }
            
            if addTapToDismissKeyboard() {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BaseUIViewController.dismissKeyboard))
                tapGesture.numberOfTapsRequired = 1
                view.isUserInteractionEnabled = true
                view.addGestureRecognizer(tapGesture)
            }
            
            createLayout()
        }
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !hasAppearedBefore {
            self.firstWillAppear()
        }
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.didAppear(first: !hasAppearedBefore)
        if !hasAppearedBefore { hasAppearedBefore = true }
    }
    
    open func initialize() {
        if shouldRespondToKeyboard() {
            NotificationCenter.default.addObserver(self, selector: #selector(BaseUIViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(BaseUIViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    open func createLayout() {
        layoutCreated = true
    }
    open func firstWillAppear() {}
    open func didAppear(first: Bool) {}
    open func frameUpdate() {}
    open func defaultBackgroundColor() -> UIColor {
        return UIColor.clear
    }
    
    
    // MARK: - Foreground Event -
    open func isVisible() -> Bool {
#if MAIN
        return (self.view.window != nil &&
            self.isViewLoaded &&
            UIApplication.shared.applicationState == .active)
#else
        return true
#endif
    }
    
    // MARK: - BaseUIViewDelegate -
    public func presentVC(_ vc: UIViewController, animated: Bool) {
        ThreadHelper.checkedExecuteOnMainThread() {
            self.present(vc, animated: true, completion: nil)
        }
    }
    open func dismissVC(_ animated: Bool) {
        ThreadHelper.checkedExecuteOnMainThread() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    public func getVc() -> UIViewController? {
        return self
    }
    
    // MARK: - Navigation Endpoints -
    
    open func tabbarItemFont() -> UIFont {
        return UIFont.systemFont(ofSize: tabbarItemFontSize())
    }
    open func tabbarItemFontSize() -> CGFloat {
        return 13
    }
    
    open func setNavigationItem(text: String?, target: AnyObject?, selector: Selector, left: Bool, font: UIFont? = nil) {
        if let t = text {
            let button = UIBarButtonItem(title: t, style: UIBarButtonItemStyle.plain, target: target ?? self, action: selector)
            button.setTitleTextAttributes([NSFontAttributeName: font ?? tabbarItemFont()], for: UIControlState())
            
            if left {
                self.navigationItem.leftBarButtonItem = button
            } else {
                self.navigationItem.rightBarButtonItem = button
            }
        }
    }
    
    open func setNavigationItem(res: String?, target: AnyObject?, action: Selector, left: Bool) {
        if let r = res, let image = UIImage(named: r) {
            
            let button = PresentationHelper.buildNavBarButton(image, target: target, action: action)
            
            
            if left {
                self.navigationItem.leftBarButtonItem = button
            } else {
                self.navigationItem.rightBarButtonItems = [
                    PresentationHelper.buildNavBarSpace(-4),
                    button]
            }
        }
    }
    
    open func setNavigationItem(_ image: UIImage?, target: AnyObject?, action: Selector,  tintColor: UIColor?, left: Bool) {
        if let i = image {
            
            let button = PresentationHelper.buildNavBarButton(i, target: target, action: action)
            
            if left {
                self.navigationItem.leftBarButtonItem = button
            } else {
                self.navigationItem.rightBarButtonItems = [
                    PresentationHelper.buildNavBarSpace(-4),
                    button]
            }
        }
    }
    
    open func addTap(_ view: UIView, selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        tapGesture.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    open func addDismissButton() -> Bool {
        return true
    }
    
    open func addTapToDismissKeyboard() -> Bool {
        return true
    }
    
    open func dismissButtonCopy() -> String {
        return "Cancel"
    }
    
    open func shouldRespondToKeyboard() -> Bool {
        return false
    }
    
    open func tableview() -> UITableView? {
        return nil
    }
    
    open func contentInsetForTableView(keyboardHeight: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    open func dismissKeyboard() {
        resignNested(view: self.view)
    }
    
    private func resignNested(view: UIView) {
        for v in view.subviews {
            v.resignFirstResponder()
            resignNested(view: v)
        }
    }
    
    open var keyboardHeight: CGFloat = 0
    open func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize: CGFloat = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            keyboardHeight = keyboardSize
        }
        
        if let tbl = self.tableview() {
            tbl.contentInset = self.contentInsetForTableView(keyboardHeight: keyboardHeight)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.frameUpdate()
            }
        }
        
    }
    
    open func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = 0
        if let tbl = self.tableview() {
            tbl.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.frameUpdate()
            }
        }
    }
}
