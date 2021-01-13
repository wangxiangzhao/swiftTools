//
//  YZTimer.swift
//  StudySwift
//
//  Created by wangxiangzhao on 2021/1/8.
//

import UIKit

class YZTimer: NSObject {
    private var timer: DispatchSourceTimer?
    
    func execute(interval: Int, now: Bool, repeating: Bool, callback: (()->())?) {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        } else {
            destory()
        }
        let start = DispatchTime.now() + .seconds(now == true ? 0 : interval)
        let leeway = DispatchTimeInterval.milliseconds(10)
        if repeating == true {
            //循环执行，间隔为s,误差允许10微秒
            timer?.schedule(deadline: start, repeating: .seconds(interval), leeway: leeway)
        } else {
            timer?.schedule(deadline: start, leeway: leeway)
        }
        timer?.setEventHandler(handler: {
            DispatchQueue.main.async {
                callback?()
            }
        })
        timer?.resume()
    }
    
    //清空计时器
    func destory() {
        timer?.cancel()
        timer = nil
    }
}
