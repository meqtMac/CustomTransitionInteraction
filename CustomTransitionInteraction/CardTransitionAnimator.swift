//
//  CardTransitionAnimator.swift
//  CustomTransitionInteraction
//
//  Created by jiangYi on 2025/8/19.
//

import UIKit

// MARK: - Card Present Animator
class CardPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let sourceFrame: CGRect
    
    init(sourceFrame: CGRect) {
        self.sourceFrame = sourceFrame
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? CardViewController
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        // 添加 blur view 背景
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = containerView.bounds
        blurView.alpha = 0
        containerView.addSubview(blurView)
        
       
        // 设置目标视图控制器的初始状态
        toViewController.view.frame = sourceFrame
        toViewController.view.alpha = 1
        containerView.addSubview(toViewController.view)
        toViewController.viewWillLayoutSubviews()
        toViewController.viewDidLayoutSubviews()
        toViewController.view.layer.cornerRadius = 16
        
        // 执行动画
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
            
           // 卡片放大并移动到最终位置，blur view 完全显示
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                toViewController.view.frame = finalFrame
                toViewController.viewWillLayoutSubviews()
                toViewController.viewDidLayoutSubviews()
                blurView.alpha = 1.0
                toViewController.view.layer.cornerRadius = 0
            }
            
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - Card Dismiss Animator
class CardDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let destinationFrame: CGRect
    
    init(destinationFrame: CGRect) {
        self.destinationFrame = destinationFrame
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? CardViewController else {
            transitionContext.completeTransition(false)
            return
        }
       
        let blurView = transitionContext.containerView.subviews.first {
            $0.isKind(of: UIVisualEffectView.classForCoder())
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveLinear], animations: {
            fromViewController.view.frame = self.destinationFrame
            fromViewController.viewWillLayoutSubviews()
            fromViewController.viewDidLayoutSubviews()
            fromViewController.view.layer.cornerRadius = 16
            fromViewController.scrollView.contentOffset = .zero
            blurView?.alpha = 0
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

