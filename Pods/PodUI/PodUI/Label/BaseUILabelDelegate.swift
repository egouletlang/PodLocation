//
//  BaseUILabelDelegate.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/23/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

@objc
public protocol BaseUILabelDelegate: NSObjectProtocol {
    @objc optional func interceptUrl(_ url: URL)->Bool
    @objc optional func active()->Void
    @objc optional func inactive()->Void
}

