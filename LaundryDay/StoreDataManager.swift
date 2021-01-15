//
//  StoreDataManager.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/13.
//

import UIKit
import Firebase

protocol StoreDataDelegate {
    func getStoreData(data: [StoreData])
}

struct StoreDataManager {
    var delegate: StoreDataDelegate?
    
   
    
    func requestFSData(_ currentAddress: String) {
        K.fs.collection(K.Table.laundry)
            .whereField("address_array", arrayContains: currentAddress)
            .addSnapshotListener { (querySnapshot, error) in
            var storeInfo: [StoreData] = []
            
            if let e = error {
                print("There was an issue retrieving data from data from Firestore \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let storeID = doc.documentID
                        let newData = StoreData(
                            address: data["address"] as! String,
                            name: data["name"] as! String,
                            latLon: data["latLng"] as! GeoPoint,
                            phoneNum: data["number"] as! String,
                            type: data["type"] as! String,
                            id: storeID
                        )
                        storeInfo.append(newData)
                        self.delegate?.getStoreData(data: storeInfo)
                    }
                    
                }
            }
        }
    }
}
