//
//  MyReviewTableCell.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/13.
//

import UIKit
import Cosmos

class MyReviewTableCell: UITableViewCell {
    // LAUNDRY Collection
    @IBOutlet weak var storeNameLabel: UIButton!
    @IBOutlet weak var storeAddressLabel: UILabel!
    // REVIEW Collection
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var writeTimeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var modifyButton: UIButton!
    
    var storeData: StoreData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        starRatingView.settings.fillMode = .half
        starRatingView.settings.starSize = 13
        starRatingView.settings.starMargin = -2
        starRatingView.settings.disablePanGestures = true
        starRatingView.settings.updateOnTouch = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func storeNameButtonAction(_ sender: Any) {
        let vc = StoreDetailVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.storeDetailData = storeData
        let currentController = self.getCurrentViewController()
        currentController?.present(vc, animated: true, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while (currentController.presentedViewController != nil) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
}
