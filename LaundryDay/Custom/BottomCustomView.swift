//
//  BottomCustomView.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/16.
//

import UIKit
import NMapsMap


class BottomCustomView: UIViewController {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeRatingLabel: UILabel!
    @IBOutlet weak var starRatingStackView: UIStackView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet var storeView: UIView!
    
    var storeName = ""
    var storeAddress = ""
    var storeDistance = ""
    var storePhoneNum = ""
    
    var bottomViewData: StoreData?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        gesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        storeDistanceLabel.text = storeDistance
        storeNameLabel.text = bottomViewData?.name
        storeAddressLabel.text = bottomViewData?.address
        storePhoneNum = bottomViewData?.phoneNum ?? ""
        
    }
    
    func gesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        singleTapGesture.numberOfTouchesRequired = 1
        storeView.addGestureRecognizer(singleTapGesture)
        
    }
    @objc func tapAction() {
        let vc = StoreDetailVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.storeDetailData = self.bottomViewData
 
        present(vc, animated: true, completion: nil)
    }

    
}
