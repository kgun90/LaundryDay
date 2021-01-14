//
//  Constants.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/12.
//

import Foundation
import Firebase

struct K {
    static let fs = Firestore.firestore()
    
    struct Where {
        static let addressArray = "address_array"
    }
    struct Table {
        static let laundry = "LAUNDRY"
        static let review = "REVIEW"
        static let members = "MEMBERS"
    }
}
