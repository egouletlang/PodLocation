//
//  GenericLabelRowTVCell.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 10/3/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics

open class GenericLabelRowTVCell: BaseRowTVCell {
    
    override open func createCell() -> BaseRowView {
        return GenericLabelRowView(frame: CGRect.zero)
    }
    
}
