//
//  BaseRowViewDelegate.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/23/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

@objc
public protocol BaseRowViewDelegate: NSObjectProtocol {
    func active(view: BaseRowView)
    func tapped(model: BaseRowModel, view: BaseRowView)
    func longPressed(model: BaseRowModel, view: BaseRowView)
    func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView)
    
    /// Invoked when isAcceptableLength is fulfilled and when state changes from OK <-> NOK to submit
    @objc optional func submitArgsValidityChanged(valid: Bool)
    
    /// Fired whenever any text was changed. May be used by parent containers if validity of submit args is more
    /// complext that can be expressed ni isAcceptableLength
    @objc optional func submitArgsChanged()
}
