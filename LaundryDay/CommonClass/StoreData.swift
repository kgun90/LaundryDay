//
//  StoreData.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/22.
//

import Foundation
import Firebase

//public protocol Persistable {
//    associatedtype ManagedObject: RealmSwift.Object
//    init(managedObject: ManagedObject)
//    func managedObject() -> ManagedObject
//}

struct StoreData {
    let address: String
    let name: String
    let latLon: GeoPoint
    let phoneNum: String
    let type: String
    let id: String
}
//
//extension StoreData: Persistable {
//
//    public init(managedObject: RecentViewedData) {
//        name = managedObject.name
//        address = managedObject.address
//        latLon = managedObject.latLon!
//        phoneNum = managedObject.phoneNum
//        type = managedObject.type
//    }
//
//    public func managedObject() -> RecentViewedData {
//        let data = RecentViewedData()
//        data.address = address
//        data.name = name
//        data.latLon = latLon
//        data.phoneNum = phoneNum
//        data.type = type
//        return data
//    }
//
//
//}
