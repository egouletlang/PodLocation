//
//  BaseRowModel.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/23/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

private let DEFAULT_PADDING = Rect<CGFloat>(10, 10, 10, 10)

let labelRowView = LabelRowView(frame: CGRect.zero)
let asynchronousRowView = AsynchronousRowView(frame: CGRect.zero)
let genericLabelRowView = GenericLabelRowView(frame: CGRect.zero)
let imageLabelRowView = ImageLabelRowView(frame: CGRect.zero)
let cardRowView = CardRowView(frame: CGRect.zero)
let imageRowView = ImageRowView(frame: CGRect.zero)
let carouselRowView = CarouselRowView(frame: CGRect.zero)
let tileRowView = TileRowView(frame: CGRect.zero)
let baseRowView = BaseRowView(frame: CGRect.zero)
let singleTextInputRowView = SingleLineTextInputRowView(frame: CGRect.zero)
let multiTextInputRowView = MultiLineTextInputRowView(frame: CGRect.zero)
let genericTextInputRowView = GenericTextInputRowView(frame: CGRect.zero)

open class BaseRowModel: NSObject {
    
    open class func build(id: String, forMeasurement: Bool) -> BaseRowView {
        if forMeasurement {
            if TileRowModel.isTileRowModel(id: id) {
                return tileRowView
            } else if LabelRowModel.isLabelRowModel(id: id) {
                return labelRowView
            } else if AsynchronousRowModel.isAsynchronousRowModel(id: id) {
                return asynchronousRowView
            } else if GenericLabelRowModel.isGenericLabelRowModel(id: id) {
                return genericLabelRowView
            } else if ImageLabelRowModel.isImageLabelRowModel(id: id) {
                return imageLabelRowView
            } else if CardRowModel.isCardRowModel(id: id) {
                return cardRowView
            } else if ImageRowModel.isImageRowModel(id: id) {
                return imageRowView
            } else if CarouselRowModel.isCarouselRowModel(id: id) {
                return carouselRowView
            } else if GenericTextInputRowModel.isGenericTextInputRowModel(id: id) {
                return genericTextInputRowView
            } else if SingleLineTextInputRowModel.isSingleLineTextInputRowModel(id: id) {
                return singleTextInputRowView
            } else if MultiLineTextInputRowModel.isMultiLineTextInputRowModel(id: id) {
                return multiTextInputRowView
            }
            return baseRowView
        }
        
        assert(Thread.isMainThread)
        if TileRowModel.isTileRowModel(id: id) {
            return TileRowView(frame: CGRect.zero)
        } else if LabelRowModel.isLabelRowModel(id: id) {
            return LabelRowView(frame: CGRect.zero)
        } else if AsynchronousRowModel.isAsynchronousRowModel(id: id) {
            return AsynchronousRowView(frame: CGRect.zero)
        } else if GenericLabelRowModel.isGenericLabelRowModel(id: id) {
            return GenericLabelRowView(frame: CGRect.zero)
        } else if ImageLabelRowModel.isImageLabelRowModel(id: id) {
            return ImageLabelRowView(frame: CGRect.zero)
        } else if CardRowModel.isCardRowModel(id: id) {
            return CardRowView(frame: CGRect.zero)
        } else if ImageRowModel.isImageRowModel(id: id) {
            return ImageRowView(frame: CGRect.zero)
        } else if CarouselRowModel.isCarouselRowModel(id: id) {
            return CarouselRowView(frame: CGRect.zero)
        } else if GenericTextInputRowModel.isGenericTextInputRowModel(id: id) {
            return GenericTextInputRowView(frame: CGRect.zero)
        } else if SingleLineTextInputRowModel.isSingleLineTextInputRowModel(id: id) {
            return SingleLineTextInputRowView(frame: CGRect.zero)
        } else if MultiLineTextInputRowModel.isMultiLineTextInputRowModel(id: id) {
            return MultiLineTextInputRowView(frame: CGRect.zero)
        }
        return BaseRowView(frame: CGRect.zero)
    }
    
    // TODO: Remove these trackers eventually.
    private static var count = 0
    open class func increaseTracker() {
        count += 1
    }
    open class func decreaseTracker() {
        count -= 1
    }
    open class func currTracker() -> Int {
        return count
    }
    override public init() {
        super.init()
        BaseRowModel.increaseTracker()
    }
    
    deinit {
        BaseRowModel.decreaseTracker()
    }
    
    open func getId() -> String {
        return "BASE"
    }
    open func getContainerHeight() -> CGFloat {
        return self.height + self.padding.top + self.padding.bottom
    }
    
    // MARK: - Borders -
    public struct BorderPadding {
        var left = Rect<CGFloat>(0, 0, 0, 0)
        var top = Rect<CGFloat>(0, 0, 0, 0)
        var right = Rect<CGFloat>(0, 0, 0, 0)
        var bottom = Rect<CGFloat>(0, 0, 0, 0)
    }
    open var borders = Rect<Bool>(false, false, false, false) // L, T, R, B
    open var borderColor: UIColor?
    open var borderPadding = BorderPadding()
    
    open func withBorders(l: Bool = false, t: Bool = false, r: Bool = false, b: Bool = false) -> BaseRowModel {
        self.setLeftBorderTo(show: l, padding: nil)
        self.setTopBorderTo(show: t, padding: nil)
        self.setRightBorderTo(show: r, padding: nil)
        self.setBottomBorderTo(show: b, padding: nil)
        return self
    }
    open func withLeftBorder(show: Bool = true, padding: Rect<CGFloat>? = nil) -> BaseRowModel {
        self.setLeftBorderTo(show: show, padding: padding)
        return self
    }
    open func withTopBorder(show: Bool = true, padding: Rect<CGFloat>? = nil) -> BaseRowModel {
        self.setTopBorderTo(show: show, padding: padding)
        return self
    }
    open func withRightBorder(show: Bool = true, padding: Rect<CGFloat>? = nil) -> BaseRowModel {
        self.setRightBorderTo(show: show, padding: padding)
        return self
    }
    open func withBottomBorder(show: Bool = true, padding: Rect<CGFloat>? = nil) -> BaseRowModel {
        self.setBottomBorderTo(show: show, padding: padding)
        return self
    }
    open func setLeftBorderTo(show: Bool, padding: Rect<CGFloat>?) {
        self.borders.left = show
        if let p = padding {
            self.borderPadding.left = p
        }
    }
    open func setTopBorderTo(show: Bool, padding: Rect<CGFloat>?){
        self.borders.top = show
        if let p = padding {
            self.borderPadding.top = p
        }
    }
    open func setRightBorderTo(show: Bool, padding: Rect<CGFloat>?) {
        self.borders.right = show
        if let p = padding {
            self.borderPadding.right = p
        }
    }
    open func setBottomBorderTo(show: Bool, padding: Rect<CGFloat>?) {
        self.borders.bottom = show
        if let p = padding {
            self.borderPadding.bottom = p
        }
    }
    
    open func withDefaultBottomBorder() -> BaseRowModel {
        self.setBottomBorderTo(show: true, padding: nil)
        return self
    }
    
    open func withBorderColor(color: UIColor? = nil) -> BaseRowModel {
        self.setBorderColorTo(color: color)
        return self
    }
    open func setBorderColorTo(color: UIColor? = nil) {
        self.borderColor = color
    }
    
    // MARK: - Padding -
    open var padding = DEFAULT_PADDING
    open func withPadding(l: CGFloat? = nil, t: CGFloat? = nil, r: CGFloat? = nil, b: CGFloat? = nil) -> BaseRowModel {
        self.padding = Rect<CGFloat>(
                            l ?? DEFAULT_PADDING.left,
                            t ?? DEFAULT_PADDING.top,
                            r ?? DEFAULT_PADDING.right,
                            b ?? DEFAULT_PADDING.bottom)
        return self
    }
    
    // MARK: - Background Color -
    open var backgroundColor: UIColor?
    open func withBackgroundColor(color: UIColor? = nil) -> BaseRowModel {
        self.setBackgroundColorTo(color: color)
        return self
    }
    open func setBackgroundColorTo(color: UIColor?) {
        self.backgroundColor = color
    }
    
    // MARK: - Height -
    open var size = CGSize.zero
    open var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            self.size.height = newValue
        }
    }
    open var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            self.size.width = newValue
        }
    }
    
    open var measureHeight = true
    open var measureWidth = true
    open func withHeight(height: CGFloat) -> BaseRowModel {
        self.setHeightTo(height: height)
        return self
    }
    open func setHeightTo(height: CGFloat) {
        self.height = height
        self.measureHeight = false
    }
    
    open func withWidth(width: CGFloat) -> BaseRowModel {
        self.setWidthTo(width: width)
        return self
    }
    open func setWidthTo(width: CGFloat) {
        self.width = width
        self.measureWidth = false
    }
    
    
    open func withSize(size: CGSize) -> BaseRowModel {
        self.setSizeTo(size: size)
        return self
    }
    open func setSizeTo(size: CGSize) {
        self.size = size
        self.measureWidth = false
        self.measureHeight = false
    }
    
    
    open var cornerRadius: CGFloat = 0
    open func withCornerRadius(radius: CGFloat) -> BaseRowModel {
        self.setCornerRadius(radius: radius)
        return self
    }
    open func setCornerRadius(radius: CGFloat) {
        self.cornerRadius = radius
    }
    
    
    // MARK: - Tag -
    open var tag: String?
    open func withTag(tag: String) -> BaseRowModel {
        self.setTagTo(tag: tag)
        return self
    }
    open func setTagTo(tag: String?) {
        self.tag = tag
    }
    
    // MARK: - Searchability -
    open static var ANY_SCOPE = ".*"
    open static var NO_SCOPE = "^.*"
    open var scope = BaseRowModel.NO_SCOPE
    open func anyScope() -> BaseRowModel {
        self.setSearchableTo(searchable: BaseRowModel.ANY_SCOPE)
        return self
    }
    open func noScope() -> BaseRowModel {
        self.setSearchableTo(searchable: BaseRowModel.NO_SCOPE)
        return self
    }
    open func withScope(scope: String) -> BaseRowModel {
        self.setScopeTo(scope: scope)
        return self
    }
    open func setScopeTo(scope: String) {
        self.scope = scope
    }
    
    open static var ANY_QUERY = ".*"
    open static var NO_QUERY = "^.*"
    open var searchable = BaseRowModel.NO_QUERY
    open func alwaysVisible() -> BaseRowModel {
        self.setSearchableTo(searchable: BaseRowModel.ANY_QUERY)
        return self
    }
    open func neverVisible() -> BaseRowModel {
        self.setSearchableTo(searchable: BaseRowModel.NO_QUERY)
        return self
    }
    open func withSearchable(searchable: String) -> BaseRowModel {
        self.setSearchableTo(searchable: searchable)
        return self
    }
    open func setSearchableTo(searchable: String) {
        self.searchable = searchable
    }
    
    
    // MARK: - Interactability -
    open var clickResponse: AnyObject?
    open var longPressResponse: AnyObject?
    open func withClickResponse(obj: AnyObject?) -> BaseRowModel {
        self.setClickResponseTo(obj: obj)
        return self
    }
    open func setClickResponseTo(obj: AnyObject?) {
        self.clickResponse = obj
    }
    open func withLongPressResponse(obj: AnyObject?) -> BaseRowModel {
        self.setLongPressResponseTo(obj: obj)
        return self
    }
    open func setLongPressResponseTo(obj: AnyObject?) {
        self.longPressResponse = obj
    }
    
    open var allowSwipe = true
    open var swipeModels = [SwipeActionModel]()
    open func addSwipeModel(model: SwipeActionModel) -> BaseRowModel {
        self.swipeModels.append(model)
        return self
    }
    
    // MARK: - Arg Collection -
    // canCollect means this model produces a cell meant to collect a user input
    open func canCollectArgs() -> Bool {
        return argCollectionKey != nil
    }
    // canSubmit means that this model will allow the user to submit the current content.
    open var canSubmitArgs = true
    open var argCollectionKey: String?
    open func withArgCollectionKey(key: String? = nil) -> BaseRowModel {
        self.setArgCollectionKeyTo(key: key)
        return self
    }
    open func setArgCollectionKeyTo(key: String?) {
        self.argCollectionKey = key
    }
    
    open var originalCollectionObj: AnyObject?
    open var argCollectionObj: AnyObject?
    open func withArgCollectionObj(obj: AnyObject? = nil) -> BaseRowModel {
        self.setArgCollectionKObjTo(obj: obj)
        return self
    }
    open func setArgCollectionKObjTo(obj: AnyObject?) {
        self.originalCollectionObj = obj
        self.argCollectionObj = obj
    }
    
    // MARK: - CleanUp -
    open func cleanUp() {}
}
