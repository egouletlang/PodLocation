//
//  CardRowCVCell.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/9/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

open class CardRowCVCell: BaseRowCVCell {
    
    override open func createCell() -> BaseRowView {
        return CardRowView(frame: CGRect.zero)
    }
    
}
