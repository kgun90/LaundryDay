//
//  StoreDataManager.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/13.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

protocol StoreDataDelegate {
    func updateStoreData(data: [StoreInformation])
    func getStoreData(data: [StoreData])
}

struct StoreInformation {
    let address: String
    let name: String
    let status: String
    let x: String
    let y: String
    let serialNum: String
    let phoneNum: String
}

struct StoreData {
    let address: String
    let name: String
    let latLon: GeoPoint
    let phoneNum: String
}

struct StoreDataManager {
    var delegate: StoreDataDelegate?
    
    let URL = "http://openapi.seoul.go.kr:8088/55476e4b4a6b67753837474c566252/json/LOCALDATA_062001/1/1000"
    let header : HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    let fs = Firestore.firestore()
    
    func requestStoreData() {
        let req = AF.request(URL)
        var storeInfo: [StoreInformation] = []
        
        req.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let row = json["LOCALDATA_062001"]["row"]
        
                for i in 0 ... 1000 {
                    if row[i]["DTLSTATENM"].stringValue.contains("영업") {
                        storeInfo.append(StoreInformation(address: row[i]["RDNWHLADDR"].stringValue,
                                                             name: row[i]["BPLCNM"].stringValue,
                                                             status: row[i]["DTLSTATENM"].stringValue,
                                                             x: row[i]["X"].stringValue,
                                                             y: row[i]["Y"].stringValue,
                                                             serialNum: row[i]["MGTNO"].stringValue,
                                                             phoneNum: row[i]["SITETEL"].stringValue
                        ))
                    }
                }
                
                self.delegate?.updateStoreData(data: storeInfo)
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func requestFSData() {
        fs.collection("LAUNDRY").addSnapshotListener { (querySnapshot, error) in
            var storeInfo: [StoreData] = []
            
            if let e = error {
                print("There was an issue retrieving data from data from Firestore \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let newData = StoreData(address: data["address"] as! String,
                                                name: data["name"] as! String,
                                                latLon: data["latLng"] as! GeoPoint,
                                                phoneNum: data["number"] as! String)
                        storeInfo.append(newData)
                        self.delegate?.getStoreData(data: storeInfo)
//                        if let name = data["name"] as? String {
//
//                        }
                    }
                }
            }
        }
    }
}
