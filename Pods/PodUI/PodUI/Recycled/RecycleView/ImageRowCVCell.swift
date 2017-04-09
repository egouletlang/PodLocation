//
//  ImageRowCVCell.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class ImageRowCVCell: BaseRowCVCell {
    
    override open func createCell() -> BaseRowView {
        return ImageRowView(frame: CGRect.zero)
    }
    
}
