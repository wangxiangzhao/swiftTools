//
//  Adpter.swift
//  StudySwift
//
//  Created by wangxiangzhao on 2021/1/7.
//

import Foundation
import UIKit
import SwiftUI

let application = UIApplication.shared

struct Adpter {
    static let screen = UIScreen.main
    //屏幕宽度
    static let screenWidth = screen.bounds.width
    //屏幕高度
    static let screenHeight = screen.bounds.height
    //状态栏高度
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    //按照375的宽度为缩放比例
    static let scale = screenWidth / 375.0
    
    //适配尺寸
    static func adpter(_ size: CGFloat) -> CGFloat {
        size * scale
    }
    
    //获取当前窗口
    static func currentWindow() -> UIWindow? {
        UIApplication.shared.windows.first
    }
    
    //屏幕底部安全区
    static func safeAreaBottom() -> CGFloat {
        let window: UIWindow? = currentWindow()
        guard window != nil else {
            return 0
        }
        if #available(iOS 11.0, *) {
            return window!.safeAreaInsets.bottom
        }
        return 0
    }
    
    //是否是刘海屏
    static func isBandScreen() -> Bool {
        safeAreaBottom() > 0
    }

    //tabbar 高度
    static func tabbarHeight() -> CGFloat {
        isBandScreen() ? 83 : 49
    }
    
    //导航栏高度
    static func navigationBarHeight() -> CGFloat {
        isBandScreen() ? 88 : 64
    }
}
