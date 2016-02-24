//
//  NavigationController.swift
//  SwipeToPopExample
//
//  Created by smartapp on 2016/02/24.
//  Copyright © 2016年 Yuya Hirayama. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
  private var interactivePopTransition: UIPercentDrivenInteractiveTransition!
  private var popRecognizer: UIPanGestureRecognizer!

  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }

  func handlePopRecognizer(recognizer: UIPanGestureRecognizer) {
    guard let view = topViewController?.view else { return }

    let progress = min(1.0, max(0.0, recognizer.translationInView(view).x / view.bounds.size.width))
    let progressThreshold: CGFloat = 0.4
    let velocity = recognizer.velocityInView(nil).x
    let velocityThreshold: CGFloat = 1000

    switch recognizer.state {
    case .Began:
      interactivePopTransition = UIPercentDrivenInteractiveTransition()
      popViewControllerAnimated(true)
    case .Changed:
      interactivePopTransition.updateInteractiveTransition(progress)
    case .Ended, .Cancelled:
      if velocity > velocityThreshold || progress > progressThreshold {
        interactivePopTransition.finishInteractiveTransition()
      } else {
        interactivePopTransition.cancelInteractiveTransition()
      }
      interactivePopTransition = nil
    default:
      break
    }
  }
}

extension NavigationController: UINavigationControllerDelegate {
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch operation {
    case .Pop:
      return SwipeToPopTransition()
    default:
      return nil
    }
  }

  func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if animationController.isKindOfClass(SwipeToPopTransition.self) {
      return interactivePopTransition
    } else {
      return nil
    }
  }

  func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
    if popRecognizer == nil {
      popRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePopRecognizer:"))
    }
    viewController.view.addGestureRecognizer(popRecognizer)
  }
}
