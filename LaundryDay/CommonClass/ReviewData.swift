//
//  ReviewData.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/13.
//

import Foundation
import Firebase

struct ReviewData {
    var writer: String
    var content: String
    var rate: Double
    var time: Date
    var laundry: DocumentReference
}
