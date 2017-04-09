//
//  BaseUICollectionView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class BaseUICollectionView: UICollectionView {
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.__initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var initialized = false
    private var currSize = CGSize.zero
    private func __initialize() {
        if !initialized {
            initialized = true
            self.initialize()
            self.createAndAddSubviews()
        }
    }
    
    override open var frame: CGRect {
        didSet {
            self.frameDidSet()
        }
    }
    
    private func frameDidSet() {
        if self.currSize != self.frame.size {
            self.currSize = self.frame.size
            self.frameUpdate()
        }
    }
    
    open func addTap(_ view: UIView, selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        tapGesture.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    open func initialize() {}
    open func createAndAddSubviews() {}
    open func frameUpdate() {}
}
