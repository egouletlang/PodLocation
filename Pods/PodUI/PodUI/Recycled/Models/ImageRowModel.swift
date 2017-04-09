//
//  ImageRowModel.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/8/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation

private let ID = "ImageRowModel"
open class ImageRowModel: BaseRowModel {
    
    override open func getId() -> String {
        return ID
    }
    
    open class func isImageRowModel(id: String) -> Bool {
        return id == ID
    }
    
    open var imageUrl: String?
    
    open var ratio: CGFloat = 1 // h / w
    open var imageHeight: CGFloat = 0
    open var imageMargins = Rect<CGFloat>(0, 0, 0, 0)
    
    open func withImage(url: String?) -> ImageRowModel {
        self.setImage(url: url)
        return self
    }
    open func withImage(height: CGFloat) -> ImageRowModel {
        self.setImage(height: height)
        return self
    }
    open func withImage(ratio: CGFloat) -> ImageRowModel {
        self.setImage(ratio: ratio)
        return self
    }
    open func withImage(margins m: Rect<CGFloat>?) -> ImageRowModel {
        self.setImage(margins: m)
        return self
    }
    open func setImage(height: CGFloat) {
        self.imageHeight = height
    }
    open func setImage(ratio: CGFloat) {
        self.ratio = ratio
    }
    open func setImage(margins m: Rect<CGFloat>?) {
        self.imageMargins = m ?? Rect<CGFloat>(0,0,0,0)
    }
    
    open func setImage(url: String?) {
        self.imageUrl = url
    }
    
    
}
