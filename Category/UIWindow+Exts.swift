//
//  UIWindow+Exts.swift
//  StudySwift
//
//  Created by wangxiangzhao on 2021/1/8.
//

import UIKit

extension UIWindow {

    //返回窗口最上层controller
    func topController() -> UIViewController? {
        var topController = self.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }

    //当前显示控制器
    func currentController() -> UIViewController? {
        var parent = self.rootViewController
        while true {
            if parent?.presentedViewController != nil {
                parent = parent?.presentedViewController
            } else if parent?.isKind(of: UINavigationController.self) == true {
                let navController: UINavigationController = parent as! UINavigationController
                if navController.topViewController != nil {
                    parent = navController.topViewController
                }
            } else if parent?.isKind(of: UITabBarController.self) == true {
                let tabbarController: UITabBarController = parent as! UITabBarController
                if tabbarController.selectedViewController != nil {
                    parent = tabbarController.selectedViewController
                }
            } else if parent?.isKind(of: UISplitViewController.self) == true {
                let splitController: UISplitViewController = parent as! UISplitViewController
                if splitController.viewControllers.last != nil {
                    parent = splitController.viewControllers.last
                }
            } else {
                break
            }
        }
        return parent
    }
}
