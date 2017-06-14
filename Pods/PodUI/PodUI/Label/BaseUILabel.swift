//
//  BaseUILabel.swift
//  Phoenix
//
//  Created by Etienne Goulet-Lang on 9/23/16.
//  Copyright © 2016 Etienne Goulet-Lang. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

private let DEFAULT_ACTIVE_BKG_COLOR = UIColor(rgb: 0xEEEEEE)
private let DEFAULT_INACTIVE_BKG_COLOR = UIColor(rgb: 0xFFFFFF)
private let DEFAULT_BORDER_COLOR = UIColor(rgb: 0x7B868C)

public class BaseUILabel: UILabel, UIGestureRecognizerDelegate {
    
    public static let OPEN_URL_EVENT = Notification.Name("event.open_url")
    
    // MARK: - Constructors -
    public init() {
        super.init(frame: CGRect.zero)
        self.__initialize()
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.__initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.__initialize()
    }
    
    // MARK: - Configuration -
    fileprivate var initialized = false
    fileprivate func __initialize() {
        if !initialized {
            initialized = true
            for layer in borderRect {
                self.layer.addSublayer(layer)
            }
            self.isUserInteractionEnabled = true
            self.initialize()
            self.addGestureRecognition()
        }
    }
    
    // MARK: - LabelInformation -
    open var labelInformation: LabelInformation? {
        didSet {
            self.attributedText = self.labelInformation?.attr
        }
    }
    
    // MARK: - Responding to Frame Changes -
    fileprivate var currSize = CGSize.zero
    override open var frame: CGRect {
        didSet {
            self.frameDidSet()
        }
    }
    // only respond to frame updates if the size changes to avoid over-drawing.
    fileprivate func frameDidSet() {
        if self.currSize != self.frame.size {
            self.currSize = self.frame.size
            self.frameUpdate()
        }
    }
    
    // MARK: - Borders -
    fileprivate let borderRect: Rect<CALayer> = {
        let ret = Rect<CALayer>(CALayer(), CALayer(), CALayer(), CALayer())
        ret.left.backgroundColor = DEFAULT_BORDER_COLOR.cgColor
        ret.top.backgroundColor = DEFAULT_BORDER_COLOR.cgColor
        ret.right.backgroundColor = DEFAULT_BORDER_COLOR.cgColor
        ret.bottom.backgroundColor = DEFAULT_BORDER_COLOR.cgColor
        return ret
    }()
    open var borders = Rect<Bool>(false, false, false, false)
    open var borderColor: CGColor? {
        get { return borderRect.left.backgroundColor }
        set {
            for border in borderRect {
                border.backgroundColor = newValue
            }
        }
    }
    
    
    func setActiveState() {
        if !allowActiveState { return }
        animate() {
            self.delegate?.active?()
            self.backgroundColor = self.activeBackgroundColor
        }
    }
    func setInactiveState() {
        if !allowActiveState { return }
        animate() {
            self.delegate?.inactive?()
            self.backgroundColor = self.inactiveBackgroundColor
            
        }
    }
    open var allowActiveState = false
    open var activeBackgroundColor: UIColor? = DEFAULT_ACTIVE_BKG_COLOR
    open var inactiveBackgroundColor: UIColor? = DEFAULT_INACTIVE_BKG_COLOR
    
    weak var delegate: BaseUILabelDelegate?
    
    // MARK: - Touch -
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !willConsumeLocationTap(touches.first?.location(in: self)) {
            setActiveState()
        }
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setInactiveState()
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    open func willConsumeLocationTap(_ point: CGPoint?) -> Bool {
        if let url = willLinkIntercept(point) {
            if !(delegate?.interceptUrl?(url) ?? false) {
                NotificationCenter.default.post(name: BaseUILabel.OPEN_URL_EVENT, object: ["url": url])
            }
            return true
        }
        return false
    }
    
    // MARK: - Links -
    open func willLinkIntercept(_ point: CGPoint?) -> URL? {
        guard var location = point, let attrText = self.attributedText else { return nil }
        
        // Are there actually links?
        if (self.labelInformation?.links.count ?? 0) <= 0 { return nil }
        
        // Init text storage, text container and layout manager
        let textStorage = NSTextStorage(attributedString: attrText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: CGSize(width: self.frame.width, height: self.frame.height))
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        var currGlyph = layoutManager.location(forGlyphAt: 0)
        var nextGlyph = layoutManager.location(forGlyphAt: 0)
        var height = currGlyph.y
        
        for i in 1 ..< layoutManager.numberOfGlyphs {
            nextGlyph = layoutManager.location(forGlyphAt: i)
            if currGlyph.x >= nextGlyph.x {
                height += currGlyph.y
            }
            currGlyph = nextGlyph
        }
        
        location.y -= (self.frame.size.height - height) / 2
        
        let charIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        
        
        var rangeIndex = 0;
        for range in self.labelInformation?.ranges ?? [] {
            if NSLocationInRange(charIndex, range) {
                if let link = self.labelInformation?.links.get(rangeIndex) {
                    return link
                }
            }
            rangeIndex += 1;
        }
        
        return nil
    }
    
    // MARK: - Animations -
    fileprivate let DEFAULT_DURATION: TimeInterval = 0.3
    func animate(_ block: @escaping ()->Void) {
        UIView.animate(
            withDuration: DEFAULT_DURATION,
            delay: 0,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: block,
            completion: nil)
    }
    
    // MARK: - Padding -
    open var padding = Rect<CGFloat>(0, 0, 0, 0)
    override open func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect,
                                                 UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right)))
    }
    override open func sizeToFit() {
        let size = self.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        self.bounds.size = CGSize(width: size.width + padding.left + padding.right,
                                  height: size.height + padding.top + padding.bottom)
    }
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return sizeThatFits(size, includePadding: true);
    }
    open func sizeThatFits(_ size: CGSize, includePadding: Bool) -> CGSize {
        if !includePadding { return super.sizeThatFits(size) }
        
        //remove padding
        let sizeWithoutPadding = CGSize(width: size.width - padding.left - padding.right,
                                        height: size.height - padding.top - padding.bottom)
        
        let retSize = super.sizeThatFits(sizeWithoutPadding)
        
        //add padding
        return CGSize(width: retSize.width + padding.left + padding.right,
                      height: retSize.height + padding.top + padding.bottom)
    }
    
    
    open func addTap(_ target: AnyObject, selector: Selector) {
        var tapGesture = UITapGestureRecognizer(target: target, action: selector)
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(BaseUILabel.setInactiveState))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Lifecycle methods which may be implemented by derived classes -
    open func initialize() {}
    open func addGestureRecognition() {}
    open func frameUpdate() {
        borderRect.left.frame = CGRect(x: 0, y: 0, width: LayoutHelper.onePixel, height: self.frame.height)
        borderRect.top.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: LayoutHelper.onePixel)
        borderRect.right.frame = CGRect(x: self.frame.width - LayoutHelper.onePixel, y: 0, width: LayoutHelper.onePixel, height: self.frame.height)
        borderRect.bottom.frame = CGRect(x: 0, y: self.frame.height - LayoutHelper.onePixel, width: self.frame.width, height: LayoutHelper.onePixel)
        
        borderRect.left.isHidden = !borders.left
        borderRect.top.isHidden = !borders.top
        borderRect.right.isHidden = !borders.right
        borderRect.bottom.isHidden = !borders.bottom
    }
}
