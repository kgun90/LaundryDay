//
//  RecentViewdData.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/23.
//

import Foundation
import Firebase
import RealmSwift

class RecentViewedData: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
