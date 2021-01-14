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
   
        K.fs.collection(K.Table.review).whereField("laundry", isEqualTo: K.fs.collection(K.Table.laundry).document(storeID)).addSnapshotListener {(querySnapshot, error) in
            var reviewData: [ReviewData] = []
    
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
                                    time: (time?.dateValue())!
                                )
                                reviewData.append(review)
                                self.delegate?.getReviewData(review)
                            }
                        })
                        
                        
                    }
                   
                }
            }
        }
//        fs.collection(K.Table.review).document(storeID).getDocument { (document, error) in
//            if let document = document, document.exists {
//                let data = document.data()
//                let review = ReviewData(
//                    writer: data!["writer"] as! String,
//                    content: data!["content"] as! String,
//                    rate: data!["rate"] as! Double,
//                    time: data!["time"] as! Date
//                )
//                self.delegate?.getReviewData(review)
//            }
//        }
    }
}
