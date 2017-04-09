//
//  OverlayPresentationController.swift
//  Wand
//
//  Created by Etienne Goulet-Lang on 10/6/15.
//  Copyright © 2015 Heine Frifeldt. All rights reserved.
//

import Foundation

private let D_CORNER_RADIUS: CGFloat = 2
private let D_MIN_BORDER_SIZE = CGSize(width: 0, height: 0)

protocol PresentationBackgroundBlurDelegate: NSObjectProtocol {
    func dimTapped()
}

class PresentationBackgroundBlurView: BaseUIView {
    
    // MARK: - UI -
    /// Semi-transparent background view to allow adjusting blur alpha
    lazy var backgroundView: UIView = {
        let ret = UIView(frame: CGRect.zero)
        ret.backgroundColor = UIColor(rgb: 0x000000)
        ret.alpha = 0.70
        return ret
    }()
    
    lazy var blurBackgroundView: UIVisualEffectView = {
        return self.createBlurBackground()
    }()
    
    private func createBlurBackground() -> UIVisualEffectView {
        let ret = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PresentationBackgroundBlurView.dimClicked))
        tapGesture.numberOfTapsRequired = 1
        ret.isUserInteractionEnabled = true
        ret.addGestureRecognizer(tapGesture)
        return ret
    }
    
    // MARK: - Delegate -
    weak var delegate: PresentationBackgroundBlurDelegate?
    
    // MARK: - Lifecycle -
    override func createAndAddSubviews() {
        super.createAndAddSubviews()
        self.addSubview(backgroundView)
        self.addSubview(blurBackgroundView)
    }
    override func frameUpdate() {
        super.frameUpdate()
        self.backgroundView.frame = self.bounds
        self.blurBackgroundView.frame = self.bounds
    }
    
    // MARK: - Tap Events -
    func dimClicked() {
        self.delegate?.dimTapped()
    }
}

class OverlayPresentationController: UIPresentationController, PresentationBackgroundBlurDelegate {
    
    static let DEFAULT_MIN_BORDER_SIZE = D_MIN_BORDER_SIZE
    
    //MARK: - UI -
    lazy var blurBackgroundView: PresentationBackgroundBlurView = {
        let ret = PresentationBackgroundBlurView()
        ret.delegate = self
        return ret
    }()
    
    private func createBlurBackground() -> UIVisualEffectView {
        
        let ret = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PresentationBackgroundBlurView.dimClicked))
        tapGesture.numberOfTapsRequired = 1
        ret.isUserInteractionEnabled = true
        ret.addGestureRecognizer(tapGesture)
        return ret
    }
    func dimTapped() {
        overlayPresentationControllerDelegate?.cleanOrSave()
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    weak var overlayPresentationControllerDelegate: OverlayPresentationControllerDelegate?
    var allowVcStackTransition = false
    
    private var cornerRadius = D_CORNER_RADIUS
    func setCornerRadius(r: CGFloat) {
        self.cornerRadius = r
    }
    
    //MARK: - Animation -
    override func presentationTransitionWillBegin() {
        // Add the dimming view and the presented view to the heirarchy
        if let containerViewBounds = getBlurBackgroundFrame(), let _presentedView = self.presentedView {
            self.blurBackgroundView.frame = containerViewBounds
            self.containerView?.addSubview(self.blurBackgroundView)
            
            self.blurBackgroundView.alpha = 0
            self.containerView?.addSubview(_presentedView)
        }
        
        // Fade in the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                if self.allowVcStackTransition {
                    self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.presentingViewController.view.center.y -= 10
                    self.presentingViewController.view.alpha = 0.7
                }
                self.blurBackgroundView.alpha = 0.8
            }, completion:nil)
        }
    }
    override func presentationTransitionDidEnd(_ completed: Bool)  {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            self.blurBackgroundView.removeFromSuperview()
        }
    }
    override func dismissalTransitionWillBegin()  {
        
        // Fade out the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                if self.allowVcStackTransition {
                    self.presentingViewController.view.transform = CGAffineTransform.identity
                    self.presentingViewController.view.center.y += 10
                    self.presentingViewController.view.alpha = 1
                }
                self.blurBackgroundView.alpha  = 0.0

            }, completion:nil)
        }
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            self.blurBackgroundView.removeFromSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            if let bounds = self.containerView?.bounds {
                self.blurBackgroundView.frame = bounds
            }
            }, completion:nil)
    }
    
    //MARK: - Size Requirements -
    private var keyboardHeight: CGFloat = 0
    private var requiredSize: CGSize?
    private var minBorderSize = DEFAULT_MIN_BORDER_SIZE
    func setRequiredSize(size: CGSize, borderSize: CGSize) {
        self.minBorderSize = borderSize
        self.requiredSize = size
    }
    func setKeyboardHeight(keyboardHeight: CGFloat) {
        self.keyboardHeight = keyboardHeight
    }
    
    //MARK: - Frame -
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            if let frame = self.containerView?.bounds, let size = requiredSize {
                let w = min(size.width, frame.size.width - 2 * minBorderSize.width)
                let h = min(size.height, frame.size.height - keyboardHeight - 2 * minBorderSize.height)
                return CGRect(x: (frame.size.width - w) / 2, y: (frame.size.height - keyboardHeight - h) / 2 + (minBorderSize.height), width: w, height: h)
            } else if let frame = self.containerView?.bounds {
                return frame.insetBy(dx: frame.size.width / 2, dy: frame.size.height / 2)
            } else {
                return CGRect.zero
            }
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        if let containerBounds = getBlurBackgroundFrame() {
            blurBackgroundView.frame = containerBounds
        }
        if let presentedView = presentedView {
            // If its growing animate it.
            presentedView.clipsToBounds = true
            presentedView.layer.cornerRadius = self.cornerRadius
            
            let targetFrame = self.frameOfPresentedViewInContainerView
            
            if targetFrame.width < presentedView.frame.width || targetFrame.height < presentedView.frame.height {
                presentedView.frame = targetFrame
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.layoutSubviews, animations: { () -> Void in
                    presentedView.frame = self.frameOfPresentedViewInContainerView
                }, completion: nil)
            }
            
        }
    }
    
    func getBlurBackgroundFrame() -> CGRect? {
        return containerView?.bounds
    }
    
}
protocol OverlayPresentationControllerDelegate: NSObjectProtocol {
    func cleanOrSave()
}
