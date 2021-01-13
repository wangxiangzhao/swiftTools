//
//  UIImage+Exts.swift
//  StudySwift
//
//  Created by wangxiangzhao on 2021/1/8.
//

import UIKit

extension UIImage {
    
    //绘制纯色图片
    static func create(color: UIColor, rect: CGRect) -> UIImage? {
        // 开始画图的上下文
        UIGraphicsBeginImageContext(rect.size);
        // 设置背景颜色
        color.set()
        // 设置填充区域
        UIRectFill(CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        // 返回UIImage
        let image = UIGraphicsGetImageFromCurrentImageContext();
        // 结束上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    //毛玻璃效果
    func blur(radius: CGFloat, completed: ((_ out: UIImage?) -> ())?) {
        let clampFilter = CIFilter(name: "CIAffineClamp")
        guard clampFilter != nil else {
            completed?(nil)
            return
        }
        clampFilter?.setValue(self.cgImage, forKey: kCIInputImageKey)
        let clampCiImage = clampFilter?.outputImage
        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
        guard gaussianBlurFilter != nil else {
            completed?(nil)
            return
        }
        gaussianBlurFilter?.setValue(clampCiImage, forKey: kCIInputImageKey)
        gaussianBlurFilter?.setValue(radius, forKey: "inputRadius")
        let gaussianBlurCiImage = gaussianBlurFilter?.outputImage
        guard gaussianBlurCiImage != nil else {
            completed?(nil)
            return
        }
        DispatchQueue.global().async {
            let context: CIContext = CIContext(options: nil)
            let imageRef = context.createCGImage(gaussianBlurCiImage!, from: self.ciImage?.extent ?? CGRect.zero)
            DispatchQueue.main.async {
                if (imageRef != nil) {
                    completed?(UIImage(cgImage: imageRef!))
                } else {
                    completed?(nil)
                }
            }
        }
    }
    
    //获取图片的base64 字符串 quality: (0,1]
    func base64(quality: CGFloat) -> String? {
        let data = jpegData(compressionQuality: quality)
        return data?.base64EncodedString(options: .lineLength64Characters)
    }
    
    //通过base64字符串生成图片
    static func create(base64: String) -> UIImage? {
        let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        guard data != nil else {
            return nil
        }
        return UIImage(data: data!)
    }
}
