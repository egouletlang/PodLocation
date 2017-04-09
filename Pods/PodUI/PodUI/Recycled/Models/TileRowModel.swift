//
//  TileRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/13/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

private let ID = "TileRowModel"
open class TileRowModel: LabelRowModel {
    
    override open func getId() -> String {
        return ID
    }
    
    open class func isTileRowModel(id: String) -> Bool {
        return id == ID
    }
    
    override public init() {
        super.init()
        self.padding = Rect<CGFloat>(0, 0, 0, 0)
        self.titleNumberOfLines = 1
        self.subTitleNumberOfLines = 1
        self.detailsNumberOfLines = 1
    }
    
    open var imageUrl: String?
    
    open func withImage(url: String?) -> TileRowModel {
        self.setImageTo(url: url)
        return self
    }
    open func setImageTo(url: String?) {
        self.imageUrl = url
    }
    
}
