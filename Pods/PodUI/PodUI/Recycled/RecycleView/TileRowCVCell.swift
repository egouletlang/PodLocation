//
//  TileRowCVCell.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/13/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class TileRowCVCell: BaseRowCVCell {
    
    override open func createCell() -> BaseRowView {
        return TileRowView(frame: CGRect.zero)
    }
    
}
