//
//  Container.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/23.
//

import Foundation
//import RealmSwift
//
//public final class WriteTransaction {
//    private let realm: Realm
//    internal init(realm: Realm) {
//        self.realm = realm
//    }
//    public func add<T: Persistable>(_ value: T, update: Bool) {
//        realm.add(value.managedObject(), update: .modified)
//    }
//}
//// Implement the Container
//public final class Container {
//    private let realm: Realm
//    public convenience init() throws {
//        try self.init(realm: Realm())
//    }
//    internal init(realm: Realm) {
//        self.realm = realm
//    }
//    public func write(_ block: (WriteTransaction) throws -> Void)
//    throws {
//        let transaction = WriteTransaction(realm: realm)
//        try realm.write {
//            try block(transaction)
//        }
//    }
//}
