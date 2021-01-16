//
//  ReportData.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/16.
//

import Foundation
import Firebase

struct ReportData {
    var name: String
    var type: String
    var address: String
    var addressArray: [String]
    var lanLng: GeoPoint
    var writer: DocumentReference
    var time: Date
    var registered: Bool
    var number: String
}
