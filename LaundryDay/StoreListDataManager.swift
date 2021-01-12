//
//  GetStoreDataManager.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/29.
//

import Foundation
import Firebase

protocol StoreListDataManagerDelegate {
    func getRecentViewedData(_ data: StoreData)
    func getFavData(_ data: StoreData)
}

struct StoreListDataManager {
    var delegate: StoreListDataManagerDelegate?
    let fs = Firestore.firestore()
    var recentViewdStoreData: [StoreData] = []
    
    func getStoreDataByID(_ storeID: String, _ mode: ListMode) {
        
        fs.collection("LAUNDRY").document(storeID).getDocument { (document, erroe) in
            if let document = document, document.exists {

                let data = document.data()
                let storeData = StoreData(address: data!["address"] as! String,
                                          name: data!["name"] as! String,
                                          latLon: data!["latLng"] as! GeoPoint,
                                          phoneNum: data!["number"] as! String,
                                          type: data!["type"] as! String,
                                          id: storeID)
                if mode == .RecentViewedStore {
                    self.delegate?.getRecentViewedData(storeData)
                } else if mode == .FavoriteStore {
                    self.delegate?.getFavData(storeData)
                    
                }
                
               
            }
        }
    }
}
