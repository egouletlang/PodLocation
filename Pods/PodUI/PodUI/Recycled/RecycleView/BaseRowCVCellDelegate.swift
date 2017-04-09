//
//  BaseRowCVCellDelegate.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

public protocol BaseRowCVCellDelegate: NSObjectProtocol {
    func active(view: BaseRowView)
    func tapped(model: BaseRowModel, view: BaseRowView)
    func longPressed(model: BaseRowModel, view: BaseRowView)
    func swipe(swipe: SwipeActionModel, model: BaseRowModel, view: BaseRowView)
    func submitArgsValidityChanged(valid: Bool)
    func submitArgsChanged()
}
