//
//  CustomPresentAnimator.swift
//  CustomTransitionInteraction
//
//  Created by jiangYi on 2025/8/19.
//

import UIKit

class CustomPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        // 设置初始状态
        toViewController.view.frame = finalFrame
        toViewController.view.alpha = 0
        toViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        containerView.addSubview(toViewController.view)
        
        // 执行动画
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: {
                toViewController.view.alpha = 1
                toViewController.view.transform = .identity
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
            }
        )
    }
}

class CustomDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        // 执行动画
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                fromViewController.view.alpha = 0
                fromViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { finished in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        )
    }
}