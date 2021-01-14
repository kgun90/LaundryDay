//
//  Date.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/14.
//

import Foundation

extension Date {
    var relativeTime_abbreviated: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
