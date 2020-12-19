//
//  UIColor.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/14.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    class var mainBackground: UIColor { UIColor(hex: 0xf5f9ff, alpha: 1)}
    class var titleBlue: UIColor { UIColor(hex: 0x004aad, alpha: 1.0)}
   
 
    
}
