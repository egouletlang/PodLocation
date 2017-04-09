//
//  CarouselRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

private let ID = "CarouselRowModel"
open class CarouselRowModel: BaseRowModel {
    
    override public init() {
        super.init()
        self.backgroundColor = UIColor(argb: 0xF8F8F8)
        self.padding = Rect<CGFloat>(0, 0, 0, 0)
    }
    
    open class func isCarouselRowModel(id: String) -> Bool {
        return id == ID
    }
    
    override open func getId() -> String {
        return ID
    }
    
    open var elements: [BaseRowModel] = []
    open func withElements(elements: [BaseRowModel]) -> BaseRowModel {
        self.setElements(elements: elements)
        return self
    }
    open func setElements(elements: [BaseRowModel]) {
        self.elements = elements
    }
    
    
}
