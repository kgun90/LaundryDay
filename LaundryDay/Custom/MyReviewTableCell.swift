//
//  MyReviewTableCell.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/13.
//

import UIKit
import Cosmos

class MyReviewTableCell: UITableViewCell {
    @IBOutlet weak var storeNameLabel: UIButton!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var writeTimeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var modifyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
