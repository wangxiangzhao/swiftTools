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
private var panKey: String = ""
private var interactiveKey: String = ""

extension UIViewController: UIViewControllerTransitioningDelegate {
    //转场样式
    private var _style: TransitionStyle {
        get {
            return  objc_getAssociatedObject(self, &styleKey) as! TransitionStyle
        }
        set {
            objc_setAssociatedObject(self, &styleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    //侧滑手势
    private var _panGesture: UIPanGestureRecognizer? {
        get {
            return  objc_getAssociatedObject(self, &panKey) as? UIPanGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &panKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    //是否开启侧滑返回
    var _interactive: Bool {
        get {
            return  objc_getAssociatedObject(self, &interactiveKey) as! Bool
        }
        set {
            objc_setAssociatedObject(self, &interactiveKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                guard _panGesture == nil else {
                    return
                }
                view.isUserInteractionEnabled = true
                _panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
                view.addGestureRecognizer(_panGesture!)
            } else {
                guard _panGesture != nil else {
                    return
                }
                if view.gestureRecognizers?.contains(_panGesture!) == true {
                    view.removeGestureRecognizer(_panGesture!)
                }
            }
        }
    }
    //设置自定义的转场动画类型
    func customPresentTransitionAnimation(_ style: TransitionStyle, interactive: Bool) {
        transitioningDelegate = self
        modalPresentationStyle = .custom;
        _style = style
        _interactive = interactive
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
    
    //MARK: 侧滑手势
    @objc private func pan(gesture: UIPanGestureRecognizer) {
        let view = gesture.view!
        let translation = gesture.translation(in: view)
        if _style == .push {
            if view.frame.minX <= 0 && translation.x < 0 {
                view.transform = CGAffineTransform(translationX: 0, y: 0);
                return
            }
            view.transform = CGAffineTransform(translationX: translation.x, y: 0);
            let percent = (translation.x) / view.bounds.size.width
            if percent >= 0.5 {
                dismiss(animated: true, completion: nil)
            }
            if gesture.state == .ended ||  gesture.state == .cancelled  || gesture.state == .failed {
                if percent < 0.5 {
                    UIView.animate(withDuration: 0.25) {
                        view.transform = CGAffineTransform(translationX: 0, y: 0);
                    }
                }
            }
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
