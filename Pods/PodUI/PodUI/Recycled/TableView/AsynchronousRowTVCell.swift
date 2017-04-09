//
//  AsynchronousRowTVCell.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/24/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics

open class AsynchronousRowTVCell: BaseRowTVCell {
    override open func createCell() -> BaseRowView {
        return AsynchronousRowView(frame: CGRect.zero)
    }
}
