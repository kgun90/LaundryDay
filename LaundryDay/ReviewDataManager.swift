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
    let fs = Firestore.firestore()
    var delegate: ReviewDataManagerDelegate?
    
    func getReviewDataByID(_ storeID: String) {
        fs.collection(K.Table.review).document(storeID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let review = ReviewData(
                    writer: data!["writer"] as! String,
                    content: data!["content"] as! String,
                    rate: data!["rate"] as! Double,
                    time: data!["time"] as! Date
                )
                self.delegate?.getReviewData(review)
            }
        }
    }
}
