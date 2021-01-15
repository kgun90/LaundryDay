//
//  NearStoreListVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/15.
//

import UIKit
import RealmSwift
import Foundation
import Firebase

enum ListMode{
    case NearStore
    case RecentViewedStore
    case FavoriteStore
    case UserReviewList
}

class StoreListVC: UIViewController, StoreListCellDelegate, ReviewDataManagerDelegate {

 
    // MARK: - UI Settings
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var topViewLabel: UILabel = {
        let label = UILabel()
        label.text = "ViewTitleLabel"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
    }()
    
    lazy var storeTableView: UITableView = {
        let tv = UITableView()
       
        return tv
    }()
    
    var storeData: [StoreData] = []
    var reviewData: [ReviewData] = []
    var contentMode: ListMode = .NearStore
    let realm = try! Realm()
    var recentViewedData: Results<RecentViewedData>!
    var getStoreDetailManager = StoreListDataManager()
    var reviewDataManager = ReviewDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSet()
        layout()
        reviewDataManager.delegate = self
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDisplayData()
        if contentMode == .UserReviewList {
            getMyReview()
        }
    }
    
    func setDisplayData() {
        switch contentMode {
        case .NearStore:
            topViewLabel.text = "내근처 세탁소"
        case .FavoriteStore:
            topViewLabel.text = "찜한 세탁소"
        case .RecentViewedStore:
            topViewLabel.text = "최근 본 세탁소"
        case .UserReviewList:
            topViewLabel.text = "내가 쓴 리뷰"
        }
    }
    
    func getMyReview() {
        if let uid = Auth.auth().currentUser?.email{
            reviewDataManager.getReviewDataByUser(uid)
        }
    }
    
    func getReviewData(_ data: ReviewData) {
        self.reviewData.append(data)
        DispatchQueue.main.async {
            self.storeTableView.reloadData()
        }
    }
    
    
    func tableViewSet() {
        storeTableView.delegate = self
        storeTableView.dataSource = self
        storeTableView.separatorColor = .clear
        storeTableView.backgroundColor = .mainBackground
        
        switch contentMode {
        case .UserReviewList:
            storeTableView.register(UINib(nibName: "MyReviewTableCell", bundle: nil), forCellReuseIdentifier: "MyReviewTableCell")
        default:
            storeTableView.register(UINib(nibName: "StoreListCustomView", bundle: nil), forCellReuseIdentifier: "StoreListCustomView")
        }
       
    }
    
    func favoriteReload() {
        DispatchQueue.main.async {
            self.storeTableView.reloadData()
        }
    }
    
   // MARK: - UI Layout Setting
    func layout() {
        view.backgroundColor = .mainBackground
        view.addSubview(topView)
        topView.addSubview(backButton)
//        topView.addSubview(searchButton)
        topView.addSubview(topViewLabel)
        view.addSubview(storeTableView)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.108)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().offset(-15)
        }
//        searchButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-26)
//            $0.centerY.equalTo(backButton.snp.centerY)
//        }
        topViewLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        storeTableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Device.screenWidth * 0.95)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    @objc private func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension StoreListVC: UITableViewDelegate, UITableViewDataSource {
    // 섹션의 개수를 데이터의 개수만큼 생성하고, 각 섹션의 로우는 1개로 정한다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentMode == .UserReviewList  ? reviewData.count : storeData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // 각 섹션에 해당하는 데이터를 넣으므로 indexPath.row 가 아니고 .section이 된다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contentMode {
        case .UserReviewList:
            let cell = self.storeTableView.dequeueReusableCell(withIdentifier: "MyReviewTableCell", for: indexPath as IndexPath) as! MyReviewTableCell
           
            cell.reviewContentLabel.text = reviewData[indexPath.section].content
            cell.starRatingView.rating = reviewData[indexPath.section].rate
            cell.writeTimeLabel.text = reviewData[indexPath.section].time.relativeTime_abbreviated
            
            
            let laundry = reviewData[indexPath.section].laundry
            laundry.getDocument { (doc, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    cell.storeNameLabel.setTitle("\(doc?["name"] as! String) >", for: .normal)
                    cell.storeAddressLabel.text = doc?["address"] as! String
                    cell.storeData = StoreData(
                        address: doc?["address"] as! String,
                        name: doc?["name"] as! String,
                        latLon: doc?["latLng"] as! GeoPoint,
                        phoneNum: doc?["number"] as! String,
                        type: doc?["type"] as! String,
                        id: doc?.documentID ?? ""
                    )
                }
            }
                       
            // 셀 선택은 되나 회색으로 바뀌지 않게 설정
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
        default:
            let cell = self.storeTableView.dequeueReusableCell(withIdentifier: "StoreListCustomView", for: indexPath as IndexPath) as! StoreListCustomView
            cell.storeNameLabel.text = storeData[indexPath.section].name
            cell.storeAddressLabel.text = storeData[indexPath.section].address
            cell.storeData = storeData[indexPath.section]
            cell.delegate = self
            
            if realm.objects(FavoriteData.self).filter("id == %@", storeData[indexPath.section].id ).first != nil {
                cell.favoriteButtonStatus = .on
                cell.favoriteButton.tintColor = .red
            } else {
                cell.favoriteButtonStatus = .off
                cell.favoriteButton.tintColor = .gray
            }
            
            // 셀 선택은 되나 회색으로 바뀌지 않게 설정
             let backgroundView = UIView()
             backgroundView.backgroundColor = .clear
             cell.selectedBackgroundView = backgroundView
             
             // Cell Shadow 작업중..
             cell.layer.cornerRadius = 10
             cell.layer.masksToBounds = false
             let shadowPath2 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height-3))
             // 그림자 시작위치
             cell.layer.shadowOffset = CGSize(width: 0, height: 1)
             // 그림자 크기와 방향
             cell.layer.shadowPath = shadowPath2.cgPath
             // 그림자 색상
             cell.layer.shadowColor = UIColor.gray.cgColor
             // 그림자 투명도
             cell.layer.shadowOpacity = 0.5
             // 그림자 radius
             cell.layer.shadowRadius = 10


             return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if contentMode != .UserReviewList {
            let vc = StoreDetailVC()
            
            vc.modalPresentationStyle = .overFullScreen
            vc.storeDetailData = self.storeData[indexPath.section]
            
            if realm.objects(FavoriteData.self).filter("id == %@", self.storeData[indexPath.section].id).first != nil {
                vc.favoriteButtonStatus = .on
            } else {
                vc.favoriteButtonStatus = .off
            }
            present(vc, animated: true, completion: nil)
        }     
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }


}
