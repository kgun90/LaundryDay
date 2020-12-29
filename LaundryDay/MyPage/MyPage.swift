//
//  MyPage.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/14.
//

import UIKit
import RealmSwift

class MyPage: UIViewController, GetStoreDataManagerDelegate {

    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ProfileImage")
        return iv
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .BasicFont(.regular, size: 18)
        
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()
    
    lazy var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.regular, size: 18)
        label.text = "이 필요합니다."
        return label
    }()
    
    lazy var myReviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("내가 쓴 리뷰 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        
        return button
    }()
    
    lazy var reportStoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("세탁소 제보 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    lazy var recentViewedStore: UIButton = {
        let button = UIButton()
        button.setTitle("최근 본 세탁소", for: .normal)
        button.setTitleColor(.titleBlue, for: .normal)
        button.addTarget(self, action: #selector(recentViewedButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var favoriteStore: UIButton = {
        let button = UIButton()
        button.setTitle("찜한 세탁소", for: .normal)
        button.setTitleColor(.titleBlue, for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        return button
    }()
    
    let recentViewCell = MyPageCustomView()
    
    let favorite1 = MyPageCustomView()
    let favorite2 = MyPageCustomView()
    let favorite3 = MyPageCustomView()
    
    var storeData: [StoreData] = []
    var getStoreDetailManager = GetStoreDataManager()
    var realm = try! Realm()
    var recentViewedData: Results<RecentViewedData>!
    var recentViewed: StoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        getStoreDetailManager.delegate = self
        listDataSet()
        
        layout()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func listDataSet() {
        recentViewedData = realm.objects(RecentViewedData.self).sorted(byKeyPath: "date", ascending: true)
        DispatchQueue.main.async {
            for i in 0 ..< self.recentViewedData.count {
                self.getStoreDetailManager.getStoreDataByID(self.recentViewedData[i].id)
            }
        }
      
        
    }
    
    func getStoreData(_ data: StoreData) {
        storeData.append(data)
        customViewDataSet()
    }
    
    func customViewDataSet() {

            self.recentViewCell.storeNameLabel.text = storeData.first!.name
            self.recentViewCell.storeAddressLabel.text = storeData.first!.address
  
    }

    func layout() {
        view.addSubview(topView)
        topView.addSubview(loginButton)
        topView.addSubview(loginStatusLabel)
        topView.addSubview(profileImage)
        topView.addSubview(myReviewButton)
        topView.addSubview(reportStoreButton)
        view.addSubview(recentViewedStore)
        view.addSubview(recentViewCell)
        view.addSubview(favoriteStore)
        
        view.addSubview(favorite1)
        view.addSubview(favorite2)
        view.addSubview(favorite3)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(Device.screenWidth * 0.9)
            $0.height.equalTo(116)
        }
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(44)
        }
        loginButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.leading.equalTo(profileImage.snp.trailing).offset(2)
        }
        loginStatusLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.leading.equalTo(loginButton.snp.trailing).offset(2)
        }
 
        
        myReviewButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo((Device.screenWidth * 0.9) * 0.5)
            $0.height.equalTo(40)
        }
        reportStoreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo((Device.screenWidth * 0.9) * 0.5)
            $0.height.equalTo(40)
        }
        
        recentViewedStore.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(30)
            $0.leading.equalTo(view.snp.leading).offset(37)
        }
        recentViewCell.snp.makeConstraints {
            $0.top.equalTo(recentViewedStore.snp.bottom).offset(6)
            $0.trailing.equalTo(view.snp.trailing).offset(-14)
            $0.width.equalTo(Device.screenWidth * 0.85)
        }
        
        favoriteStore.snp.makeConstraints {
            $0.top.equalTo(recentViewCell.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(37)
        }
        
        favorite1.snp.makeConstraints {
            $0.top.equalTo(favoriteStore.snp.bottom).offset(6)
            $0.trailing.equalTo(view.snp.trailing).offset(-14)
            $0.width.equalTo(Device.screenWidth * 0.85)
        }
        favorite2.snp.makeConstraints {
            $0.top.equalTo(favorite1.snp.bottom).offset(11)
            $0.trailing.equalTo(view.snp.trailing).offset(-14)
            $0.width.equalTo(Device.screenWidth * 0.85)
        }
        favorite3.snp.makeConstraints {
            $0.top.equalTo(favorite2.snp.bottom).offset(11)
            $0.trailing.equalTo(view.snp.trailing).offset(-14)
            $0.width.equalTo(Device.screenWidth * 0.85)
        }
    }
    
    @objc func loginAction() {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .overFullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func recentViewedButtonAction() {
        let vc = StoreListVC()
        
        vc.modalPresentationStyle = .overFullScreen
        vc.contentMode = .RecentViewedStore
        vc.storeData = self.storeData
     
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func favoriteButtonAction() {
        let vc = StoreListVC()
        vc.contentMode = .FavoriteStore
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
