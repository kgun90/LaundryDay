//
//  ReviewCustomCell.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/18.
//

import UIKit
import Cosmos

class ReviewCustomCell: UITableViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var writeTimeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var starRatingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        starRatingView.settings.fillMode = .half
        starRatingView.settings.starSize = 16
        starRatingView.settings.starMargin = 0
        starRatingView.settings.disablePanGestures = true
        starRatingView.settings.updateOnTouch = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
