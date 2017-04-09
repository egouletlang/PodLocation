//
//  ImageRowTVCell.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class ImageRowTVCell: BaseRowTVCell {
    
    override open func createCell() -> BaseRowView {
        return ImageRowView(frame: CGRect.zero)
    }
    
}
