//
//  UIFont.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/14.
//

import UIKit

extension UIFont {
    public enum FontType: String {
        case bold = "Bold"
        case medium = "Medium"
        case regular = "Regular"
        case semiBold = "SemiBold"
    
    }

    static func BasicFont(_ type: FontType, size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-\(type.rawValue)", size: size)!
    }
    
    
}
