//
//  UIImage.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/16.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)  // 第3引数のscaleを0.0にすると、元の画像のスケールを使用します。
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    func resized(withSize size: CGSize) -> UIImage? {
        let aspectRatio = self.size.width / self.size.height

        var resizedSize: CGSize
        if size.width / size.height > aspectRatio {
            resizedSize = CGSize(width: size.height * aspectRatio, height: size.height)
        } else {
            resizedSize = CGSize(width: size.width, height: size.width / aspectRatio)
        }

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
