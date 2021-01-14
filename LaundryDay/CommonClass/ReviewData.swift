//
//  ReviewData.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/13.
//

import Foundation
import Firebase

struct ReviewData {
    var writer: String
    var content: String
    var rate: Double
    var time: Date
//    var nickname: String
    
    
//    init(writer: DocumentReference, content: String, rate: Double, time: Date) {
//        self.writer = writer
//        self.content = content
//        self.rate = rate
//        self.time = time
//        writer.getDocument { (document, error) in
//            if let e = error {
//                print(e.localizedDescription)
//            } else {
//                self.nickname = document!["nickname"] as? String
//            }
//        }
//
//    }
//
//
}
