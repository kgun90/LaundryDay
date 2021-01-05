//
//  FavoriteData.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/30.
//

import Foundation
import RealmSwift

class FavoriteData: Object {
    @objc dynamic var id = ""
   
    override static func primaryKey() -> String? {
        return "id"
    }
}
