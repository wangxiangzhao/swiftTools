//
//  NSString+Exts.swift
//  StudySwift
//
//  Created by wangxiangzhao on 2021/1/7.
//

import UIKit

extension NSString {
    
}

extension String {
    static func string<T>(_ from: T?) -> String {
        if from == nil {
            return ""
        }
        if T.self == String.self {
            return from as! String
        }
        return "\(from!)"
    }
}
