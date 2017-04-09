//
//  LabelRowTVCell.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/6/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics

open class LabelRowTVCell: BaseRowTVCell {
    
    override open func createCell() -> BaseRowView {
        return LabelRowView(frame: CGRect.zero)
    }
    
}
