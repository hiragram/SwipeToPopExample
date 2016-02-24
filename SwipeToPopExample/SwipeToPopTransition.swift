//
//  SwipeToPopTransition.swift
//  SwipeToPopExample
//
//  Created by smartapp on 2016/02/24.
//  Copyright © 2016年 Yuya Hirayama. All rights reserved.
//

import UIKit

class SwipeToPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
  let duration: NSTimeInterval = 0.3

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }

  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else { return }
    guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }
    guard let containerView = transitionContext.containerView() else { return }

    // Add view of destionation controller
    containerView.addSubview(toVC.view)
    containerView.bringSubviewToFront(fromVC.view)

    // Fix frame to slide
    let finalFrame = transitionContext.finalFrameForViewController(toVC)
    let xOffset: CGFloat = 100
    toVC.view.frame = CGRect(origin: CGPoint(x: finalFrame.origin.x - xOffset, y: finalFrame.origin.y), size: finalFrame.size)

    // Add brightness container view
    let black = UIView(frame: toVC.view.bounds)
    black.backgroundColor = UIColor.blackColor()
    black.alpha = 0.2
    toVC.view.addSubview(black)

    UIView.animateWithDuration(duration, animations: { () -> Void in
      fromVC.view.frame = CGRect(x: toVC.view.frame.size.width, y: fromVC.view.frame.origin.y, width: fromVC.view.frame.size.width, height: fromVC.view.frame.size.height)
      toVC.view.frame = finalFrame
      black.alpha = 0
      }) { (_) -> Void in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        black.removeFromSuperview()
    }
  }
}