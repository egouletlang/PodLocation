//
//  BaseUIImageView.swift
//  PodUI
//
//  Created by Etienne Goulet-Lang on 12/6/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import PodImage
import BaseUtils

private let instance = BaseUIImageView()
open class BaseUIImageView: BaseUIView {
    
    private let imageView = UIImageView(frame: CGRect.zero)
    
    override open func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    override open func frameUpdate() {
        super.frameUpdate()
        self.imageView.frame = self.bounds.insetBy(dx: padding.left + padding.right, dy: padding.top + padding.bottom)
        self.imageView.frame.origin = CGPoint(x: padding.left, y: padding.top)
    }
    
    open func setContentMode(contentMode: UIViewContentMode) {
        imageView.contentMode = contentMode
    }
    
    open var padding = Rect<CGFloat>(0, 0, 0, 0) {
        didSet {
            ThreadHelper.checkedExecuteOnMainThread {
                self.frameUpdate()
            }
        }
    }
    
    // MARK - Load Image Logic -
    private var currLoading = ""
    private let lock = Lock()
    
    private func shouldLoad(str: String) -> Bool {
        var shouldLoad = false
        lock.withLock { [weak self] in
            if let s = self, s.currLoading != str {
                shouldLoad = true
                s.currLoading = str
            }
        }
        return shouldLoad
    }
    private func isCurrent(str: String) -> Bool {
        var isCurrent = false
        lock.withLock { [weak self] in
            if let s = self, s.currLoading == str {
                isCurrent = true
            }
        }
        return isCurrent
    }
    
    private func getImage(str: String,
                          transforms: [BaseImageTransform]?,
                          callback: @escaping (ImageResponse?)->Void) {
        let imageRequest = ImageRequest(key: str, transforms: transforms)
        ImageManager.instance.get(request: imageRequest) { (resp) in
            callback(resp)
        }
    }
    
    /// Load an image from [Assets, Library, Web]. The cache will be managed automatically
    open func load(str: String?,
                   transforms: [BaseImageTransform]? = nil,
                   callback: ((UIImage?)->Void)? = nil) {
        
        guard let s = str else {
            self.load(img: nil)
            return
        }
        ThreadHelper.executeOnBackgroundThread {
            // Check if we should load
            if !self.shouldLoad(str: s) { return }
            
            // Set Display image to nil, and fetch the image
            self.load(img: nil)
            self.getImage(str: s, transforms: transforms) { (resp: ImageResponse?) in
                // Load Image if appropriate
                if self.isCurrent(str: s) {
                    self.load(img: resp?.image)
                    callback?(resp?.image)
                }
            }
        }
        
    }
    
    open func clear() {
        self.currLoading = ""
    }
    
    /// Load an asset image. The cache will be managed automatically
    open func loadAsset(name: String,
                        transforms: [BaseImageTransform]? = nil,
                        callback: ((UIImage?)->Void)? = nil) {
        self.load(str: ImageManager.buildAssetUri(name: name), transforms: transforms, callback: callback)
    }
    
    /// Load a gallery image. The cache will be managed automatically
    open func loadFromAlbum(name: String,
                            transforms: [BaseImageTransform]? = nil,
                            callback: ((UIImage?)->Void)? = nil) {
        self.load(str: ImageManager.buildAlbumUri(name: name), transforms: transforms, callback: callback)
    }
    
    /// Override the current image
    open func load(img: UIImage?) {
        ThreadHelper.checkedExecuteOnMainThread {
            self.imageView.image = img
        }
    }
    
}
