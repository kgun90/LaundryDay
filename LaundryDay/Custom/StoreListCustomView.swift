//
//  StoreListCustomView.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/15.
//

import UIKit
import RealmSwift

protocol StoreListCellDelegate {
    func favoriteReload()
}

class StoreListCustomView: UITableViewCell {
    
    enum buttonStatus {
        case on
        case off
    }
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeRatingLabel: UILabel!
    @IBOutlet weak var starRatingStackView: UIStackView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    var favoriteButtonStatus: buttonStatus?
    var realm = try! Realm()
    var storeData: StoreData?
    
    var delegate: StoreListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
 
   
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    @IBAction func favoriteButtonAction(_ sender: Any) {
        if favoriteButtonStatus == .off {
            favoriteAction()
            favoriteButtonStatus = .on
            favoriteButton.tintColor = .red
        } else if favoriteButtonStatus == .on {
            favoriteAction()
            favoriteButtonStatus = .off
            favoriteButton.tintColor = .gray
        }
        self.delegate?.favoriteReload()
    }
    
    func favoriteAction() {
        let favoriteData = FavoriteData()
        let id = storeData!.id
        let objectToDelete = realm.objects(FavoriteData.self).filter("id == %@", id)
        
        favoriteData.id = id
        print(favoriteButtonStatus)
        try! realm.write{
            if favoriteButtonStatus == .off {
                realm.add(favoriteData, update: .modified)
            } else if favoriteButtonStatus == .on {
                realm.delete(objectToDelete)
            }
           
        }
    }
}
