//
//  ReviewDataManager.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/13.
//

import Foundation
import Firebase

protocol ReviewDataManagerDelegate {
    func getReviewData(_ data: ReviewData)
}

struct ReviewDataManager {
    var delegate: ReviewDataManagerDelegate?
    
    func getReviewDataByID(_ storeID: String) {
        K.fs.collection(K.Table.review)
            .whereField("laundry", isEqualTo: K.fs.collection(K.Table.laundry).document(storeID)).order(by: "time")
            .addSnapshotListener {(querySnapshot, error) in
    
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let data = doc.data()                        
                        let time = data["time"] as? Timestamp
                        let writer = data["writer"] as? DocumentReference
                        var nickname = ""
                        writer?.getDocument(completion: { (document, error) in
                            if let e = error {
                                print(e.localizedDescription)
                            } else {
                                nickname = document?.get("nickname") as! String
                                print(nickname)
                                let review = ReviewData(
                                    writer: nickname,
                                    content: data["content"] as! String,
                                    rate: data["rate"] as! Double,
                                    time: (time?.dateValue())!,
                                    laundry: data["laundry"] as! DocumentReference
                                )
                                self.delegate?.getReviewData(review)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func getReviewDataByUser(_ UserID: String) {
        K.fs.collection(K.Table.review)
            .whereField("writer", isEqualTo: K.fs.collection(K.Table.members).document(UserID)).order(by: "time", descending: true)
            .addSnapshotListener {(querySnapshot, error) in
    
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let data = doc.data()
                        let time = data["time"] as? Timestamp
                        let writer = data["writer"] as? DocumentReference
                        var nickname = ""
                        writer?.getDocument(completion: { (document, error) in
                            if let e = error {
                                print(e.localizedDescription)
                            } else {
                                nickname = document?.get("nickname") as! String
                                print(nickname)
                                let review = ReviewData(
                                    writer: nickname,
                                    content: data["content"] as! String,
                                    rate: data["rate"] as! Double,
                                    time: (time?.dateValue())!,
                                    laundry: data["laundry"] as! DocumentReference
                                )
                                self.delegate?.getReviewData(review)
                            }
                        })
                        
                        
                    }
                   
                }
            }
        }
    }
}
