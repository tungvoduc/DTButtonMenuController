//
//  TransitionController.swift
//  Pods
//
//  Created by tungvoduc on 17/03/2017.
//
//

import UIKit

class TransitionController: NSObject {
    var transitionAnimator: AnyObject!
    
    unowned var menuController: DTButtonMenuController
    
    /// Default value 0.5. Set duration of transition.
    var transitionDuration: TimeInterval = 0.3
    
    init(menuController controller: DTButtonMenuController) {
        menuController = controller
        super.init()
        controller.transitioningDelegate = self
        
        if #available(iOS 10.0, *) {
            let timingParameters = UISpringTimingParameters(mass: 4.5, stiffness: 1300, damping: 600, initialVelocity: CGVector(dx: 0.5, dy: 0.5))
            transitionAnimator = UIViewPropertyAnimator(duration: transitionDuration, timingParameters:timingParameters)
        }
        else {
            
        }
    }
}

//MARK: UIViewControllerTransitioningDelegate
extension TransitionController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
}

//MARK: UIViewControllerAnimatedTransitioning
extension TransitionController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        let container = transitionContext.containerView
        let isPrensting = toViewController.presentingViewController == fromViewController
        
        let alpha: CGFloat = isPrensting ? 1.0 : 0.0
        
        // Calculate each item's position before animation
        if isPrensting {
            calculateItemPositions(with: toViewController.view.bounds.size)
            
            // Add view when presenting
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            container.addSubview(toViewController.view)
        }
        else {
            calculateItemPositions(with: fromViewController.view.bounds.size)
        }
        
        if #available(iOS 10.0, *) {
            // Add other animation: buttons + background color
            if let animator = transitionAnimator as? UIViewPropertyAnimator {
                for item in menuController.items {
                    animator.addAnimations({
                        if isPrensting {
                            item.view.center = item.position
                        }
                        else {
                            item.view.center = self.menuController.touchPoint
                        }
                    })
                }
                
                // Background color
                animator.addAnimations({
                    self.menuController.view.alpha = alpha
                })
                
                animator.addCompletion({ (position: UIViewAnimatingPosition) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
                animator.startAnimation()
            }
        }
        else {
            UIView.animate(withDuration: transitionDuration, animations: { 
                for item in self.menuController.items {
                    if isPrensting {
                        item.view.center = item.position
                    }
                    else {
                        item.view.center = self.menuController.touchPoint
                    }
                }
                
                // Background color
                self.menuController.view.alpha = alpha
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
    
    /// Calculate position of each items with this method.
    /// Size is the current size of view controller's view.
    /// Calculation of positions should based on size, touchPoint and itemSize.
    func calculateItemPositions(with size: CGSize) {
        let positioningProvider = ButtonPositioningDriver(numberOfButtons: menuController.items.count, buttonRadius: menuController.itemSize.width/2)
        positioningProvider.distance = menuController.itemsDistanceToTouchPoint
        
        let positions = positioningProvider.positionsOfItemsInView(with: menuController.view.bounds.size, at: menuController.touchPoint)
        
        for (index, position) in positions.enumerated() {
            menuController.items[index].position = position
        }
    }
}
