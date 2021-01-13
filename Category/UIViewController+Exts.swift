//
//  UIViewController+Exts.swift
//  StudySwift
//
//  Created by wangxiangzhao on 2021/1/8.
//

import UIKit

enum TransitionStyle {
    case push;                  //类似导航压栈
}

private var styleKey: String = ""

extension UIViewController: UIViewControllerTransitioningDelegate {
    
    private var _style: TransitionStyle {
        get {
            return  objc_getAssociatedObject(self, &styleKey) as! TransitionStyle
        }
        set {
            objc_setAssociatedObject(self, &styleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func customPresentTransitionAnimation(style: TransitionStyle) {
        transitioningDelegate = self
        modalPresentationStyle = .custom;
        _style = style
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch _style {
        case .push:
            return _PushAnimation()
//        default:
//            return nil
        }
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch _style {
        case .push:
            return _DismissAnimation()
//        default:
//            return nil
        }
    }

}

private class _PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: .to)
        guard toVC != nil else {
            return
        }
        let screenBounds = UIScreen.main.bounds
        let targetFrame = transitionContext.finalFrame(for: toVC!)
        containerView.addSubview(toVC!.view)
        toVC!.view.frame = CGRect(x: screenBounds.width, y: 0, width: targetFrame.width, height: targetFrame.height)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            toVC!.view.frame = targetFrame;
        } completion: { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}

private class _DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        guard fromVC != nil else {
            return
        }
        let screenBounds = UIScreen.main.bounds
        let targetFrame = CGRect(x: screenBounds.width, y: 0, width: fromVC!.view.bounds.width, height: fromVC!.view.bounds.height)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            fromVC!.view.frame = targetFrame;
        } completion: { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}
