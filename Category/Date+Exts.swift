//
//  Date+Exts.swift
//  StudySwift
//
//  Created by wangxiangzhao on 2021/1/8.
//

import UIKit

extension Date {
    
    //通过字符串和format生成date
    static func create(string: String, dateFormat: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.date(from: string)
    }
    
    //返回格式化后的字符串
    func format(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
