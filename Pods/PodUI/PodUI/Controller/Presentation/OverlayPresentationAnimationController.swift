//
//  OverlayPresentationAnimationController.swift
//  Wand
//
//  Created by Etienne Goulet-Lang on 10/6/15.
//  Copyright © 2015 Heine Frifeldt. All rights reserved.
//

import Foundation

private let DEFAULT_DURATION: TimeInterval = 0.5

class TransitionDescriptor {
    init(point: CGPoint, scale: CGFloat) {
        self.point = point
        self.scale = scale
    }
    
    var point: CGPoint
    var scale: CGFloat
    
    var translationDuration: Double?
    func withTranslationDuration(dur: Double?) -> TransitionDescriptor {
        self.translationDuration = dur
        return self
    }
    
    var translationSpring: CGFloat?
    func withTranslationSpring(spring: CGFloat?) -> TransitionDescriptor {
        self.translationSpring = spring
        return self
    }
    
    var scaleDuration: Double?
    func withScaleDuration(dur: Double?) -> TransitionDescriptor {
        self.scaleDuration = dur
        return self
    }
    var scaleSpring: CGFloat?
    func withScaleSpring(spring: CGFloat?) -> TransitionDescriptor {
        self.scaleSpring = spring
        return self
    }
}


class OverlayPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var allowSpringyAnimation = true
    var isPresenting = false
    var duration = DEFAULT_DURATION
    
    init(isPresenting: Bool, allowSpringyAnimation: Bool) {
        super.init()
        self.isPresenting = isPresenting
        self.allowSpringyAnimation = allowSpringyAnimation
    }
    
    // ---- UIViewControllerAnimatedTransitioning methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext: transitionContext)
        }
        else {
            animateDismissalWithTransitionContext(transitionContext: transitionContext)
        }
    }
    
    // ---- Helper methods
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containerView = transitionContext.containerView
        
        
        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        let finalFrame = presentedControllerView.frame
        
        let start = TransitionDescriptor(
                point: CGPoint(
                    x: presentedControllerView.center.x,
                    y: presentedControllerView.center.y + (containerView.bounds.size.height )),
                scale: 1)
        
        presentedControllerView.center = start.point
        presentedControllerView.transform = CGAffineTransform(scaleX: start.scale, y: start.scale)
        
        containerView.addSubview(presentedControllerView)
        
        let scaleDuration = start.scaleDuration ?? 0.2
        
        let translationDuration = start.translationDuration ?? self.duration
        let translationSpirng = allowSpringyAnimation ? (start.translationSpring ?? 0.8) : 1
        
        // Animate the presented view to it's final position
        UIView.animate(
            withDuration: scaleDuration,
            delay: 0.0,
            options: .allowUserInteraction,
            animations: {
                presentedControllerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
            completion: nil)
        
        UIView.animate(
            withDuration: translationDuration,
            delay: 0.0,
            usingSpringWithDamping: translationSpirng,
            initialSpringVelocity: 0.0,
            options: .allowUserInteraction,
            animations: {
                presentedControllerView.frame.origin = finalFrame.origin
            }, completion: { (completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
                presentedControllerView.transform = CGAffineTransform.identity
            })
    }
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let containerView = transitionContext.containerView
        
        let end = TransitionDescriptor(
            point: CGPoint(
                x: presentedControllerView.center.x,
                y: presentedControllerView.center.y + (containerView.bounds.size.height)),
            scale: 1)
        
        
        let scaleDuration = end.scaleDuration ?? 0.2
        
        let translationDuration = end.translationDuration ?? self.duration
        let translationSpirng = allowSpringyAnimation ? (end.translationSpring ?? 0.8) : 1
        
        // Animate the presented view to it's final position
        UIView.animate(
            withDuration: scaleDuration,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                presentedControllerView.transform = CGAffineTransform(scaleX: end.scale, y: end.scale)
            },
            completion: nil)
        
        UIView.animate(
            withDuration: translationDuration,
            delay: 0.0,
            usingSpringWithDamping: translationSpirng,
            initialSpringVelocity: 0.0,
            options: .curveEaseOut,
            animations: {
                presentedControllerView.frame.origin = end.point
                presentedControllerView.alpha = 0
            }, completion: { (completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
                presentedControllerView.transform = CGAffineTransform.identity
                presentedControllerView.alpha = 1
        })
    }
    
}
