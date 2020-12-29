//
//  GetStoreDataManager.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/29.
//

import Foundation
import Firebase

protocol GetStoreDataManagerDelegate {
    func getStoreData(_ data: StoreData)
}

struct GetStoreDataManager {
    var delegate: GetStoreDataManagerDelegate?
    let fs = Firestore.firestore()
       
    func getStoreDataByID(_ storeID: String) {
        fs.collection("LAUNDRY").document(storeID).getDocument { (document, erroe) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let data = document.data()
                let storeData = StoreData(address: data!["address"] as! String,
                                          name: data!["name"] as! String,
                                          latLon: data!["latLng"] as! GeoPoint,
                                          phoneNum: data!["number"] as! String,
                                          type: data!["type"] as! String,
                                          id: storeID)
                self.delegate?.getStoreData(storeData)
            }
        }
    }
}
