//
//  UIView+Exts.swift
//  StudySwift
//
//  Created by wangxiangzhao on 2021/1/7.
//

import UIKit

//MARK: frame 相关
extension UIView {
    
    //x 起点坐标
    var x: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            frame.origin.x
        }
    }
    
    //y 起点坐标
    var y: CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            frame.origin.y
        }
    }
    
    //width
    var width: CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            frame.size.width
        }
    }
    
    //height
    var height: CGFloat {
        set {
            frame.size.height = newValue
        }
        get {
            frame.size.height
        }
    }
    
    //最大 x坐标
    var maxX: CGFloat {
        get {
            frame.maxX
        }
    }
    
    //最大 y坐标
    var maxY: CGFloat {
        get {
            frame.maxY
        }
    }
}

//MARK: 事件相关
extension UIView {
    
    private struct AssociatedKey {
        static var tapGesture = "tapGesture"
        static var tapAction = "tapAction"
    }
    
    private var tapGesture: UITapGestureRecognizer? {
        get {
            objc_getAssociatedObject(self, &AssociatedKey.tapGesture) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.tapGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var tapAction: (()->())? {
        get {
            objc_getAssociatedObject(self, &AssociatedKey.tapAction) as? () -> ()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.tapAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    //添加点击手势
    func taped(_ action: (()->())?) {
        isUserInteractionEnabled = true
        guard action != nil else {
            return
        }
        tapAction = action
        guard tapGesture == nil else {
            return
        }
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(__clicked))
        addGestureRecognizer(tapGesture!)
    }
    
    @objc private func __clicked() {
        tapAction?()
    }
}

//MARK: 截图
extension UIView {
    func shot() -> UIImage? {
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0);
        self.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

//MARK: 动画相关
extension UIView {
    //左右抖动动画
    func shake(offset: CGFloat, duration: Double, repeatCount: Float, timingFunction: CAMediaTimingFunctionName) {
        let layer = self.layer
        let position = layer.position
        let point1 = CGPoint(x: position.x - offset, y: position.y)
        let point2 = CGPoint(x: position.x + offset, y: position.y)
        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        animation.fromValue = NSValue(cgPoint: point1)
        animation.toValue = NSValue(cgPoint: point2)
        animation.autoreverses = true
        animation.duration = duration
        animation.repeatCount = repeatCount
        layer.add(animation, forKey: nil)
    }
}
