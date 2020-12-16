//
//  BottomCustomView.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/16.
//

import UIKit

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
    
    var storeName = ""
    var storeAddress = ""
    var storeDistance = ""
    var storePhoneNum = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        storeNameLabel.text = storeName
        storeAddressLabel.text = storeAddress
        storeDistanceLabel.text = storeDistance
    }

}
