//
//  ReviewCustomCell.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/18.
//

import UIKit

class ReviewCustomCell: UITableViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var writeTimeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var rateStarStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
