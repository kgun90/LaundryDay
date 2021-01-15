//
//  MyPage.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/14.
//

import UIKit
import RealmSwift
import FirebaseAuth

class MyPage: UIViewController, StoreListDataManagerDelegate {
    enum ListMode {
        case RecentViewed
        case Favorite
    }

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
        button.addTarget(self, action: #selector(myReviewAction), for: .touchUpInside)
        
        return button
    }()
    
    lazy var reportStoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("세탁소 제보 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(reportStoreButtonAction), for: .touchUpInside)
        return button
    }()

    lazy var recentViewedStore: UIButton = {
        let button = UIButton()
        button.setTitle("최근 본 세탁소 >", for: .normal)
        button.setTitleColor(.titleBlue, for: .normal)
        button.addTarget(self, action: #selector(recentViewedButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var favoriteStore: UIButton = {
        let button = UIButton()
        button.setTitle("찜한 세탁소 >", for: .normal)
        button.setTitleColor(.titleBlue, for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃하기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .BasicFont(.semiBold, size: 13)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        return button
    }()
    
    let myPageFavoriteCell = MyPageCustomView()
    
    let myPageRecentViewdCell1 = MyPageCustomView()
    let myPageRecentViewdCell2 = MyPageCustomView()
    let myPageRecentViewdCell3 = MyPageCustomView()
    
    let myPageRecentViewedCell = [MyPageCustomView(),MyPageCustomView(),MyPageCustomView()]
    
    var storeData: [StoreData] = []
    var getStoreDetailManager = StoreListDataManager()
    var realm = try! Realm()
    var recentViewedResult: Results<RecentViewedData>!
    var recentViewed: [StoreData] = []
    
    var favoriteResult: Results<FavoriteData>!
    var favData: [StoreData] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        getStoreDetailManager.delegate = self
        
        listRecentViewedSet()
        listFavData()
        layout()
        loginCheck()
       
    }
    
    func listFavData() {
        favoriteResult = realm.objects(FavoriteData.self)
        favoriteResult.forEach {
            self.getStoreDetailManager.getStoreDataByID($0.id, .FavoriteStore)
        }
       
    }
    
    func getFavData(_ data: StoreData) {
        favData.append(data)
        DispatchQueue.main.async {
            self.favoriteDataSet()
        }
        
    }
    
    func favoriteDataSet() {
        self.myPageFavoriteCell.storeNameLabel.text = self.favData.first?.name
        self.myPageFavoriteCell.storeAddressLabel.text = self.favData.first?.address
        self.myPageFavoriteCell.storeData = self.favData.first

    }
    
    func listRecentViewedSet() {
        recentViewedResult = realm.objects(RecentViewedData.self).sorted(byKeyPath: "date", ascending: true)
        
        recentViewedResult.forEach {
            self.getStoreDetailManager.getStoreDataByID($0.id, .RecentViewedStore)
        }
       
    }
    
    func getRecentViewedData(_ data: StoreData) {
        recentViewed.append(data)
       
        if recentViewed.count > 3 {
            recentViewedDataSet()
        }
        
    }
    
    func recentViewedDataSet() {
        for i in 0 ..< 3 {
            myPageRecentViewedCell[i].storeNameLabel.text = self.recentViewed[i].name
            myPageRecentViewedCell[i].storeData = self.recentViewed[i]
        }
       
    }
    
    func loginCheck() {
        if let id = Auth.auth().currentUser?.email {
            loginButton.setTitle(id, for: .normal)
            loginButton.isEnabled = false
            loginStatusLabel.text = "님 반갑습니다."
            
            
            logoutButton.isHidden = false
        } else {
            myReviewButton.isEnabled = false
            myReviewButton.setTitleColor(.lightGray, for: .normal)
            
            reportStoreButton.isEnabled = false
            reportStoreButton.setTitleColor(.lightGray, for: .normal)
            
            logoutButton.isHidden = true
        }
    }

    @objc func logoutAction() {
        let firebaseAuth = Auth.auth()
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            do {
              try firebaseAuth.signOut()
                let vc = ViewController()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = vc
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                } else {
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        self.presentAlert(
            title: "로그아웃",
            message: "진행하시겠습니까?",
            with: ok, cancel
        )
    }
    
    func layout() {
        view.addSubview(topView)
        topView.addSubview(loginButton)
        topView.addSubview(loginStatusLabel)
        topView.addSubview(profileImage)
        topView.addSubview(myReviewButton)
        topView.addSubview(reportStoreButton)
        
        view.addSubview(recentViewedStore)
        view.addSubview(myPageFavoriteCell)
        
        view.addSubview(favoriteStore)
        
        for i in 0 ..< 3 {
            view.addSubview(myPageRecentViewedCell[i])
        }

        view.addSubview(logoutButton)
      
        
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
        
        favoriteStore.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(30)
            $0.leading.equalTo(view.snp.leading).offset(37)
        }
        myPageFavoriteCell.snp.makeConstraints {
            $0.top.equalTo(favoriteStore.snp.bottom).offset(6)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(Device.screenWidth * 0.85)
        }
        
        recentViewedStore.snp.makeConstraints {
            $0.top.equalTo(myPageFavoriteCell.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(37)
        }
        
        for i in 0 ..< 3 {
            myPageRecentViewedCell[i].snp.makeConstraints {
                if i == 0 {
                    $0.top.equalTo(recentViewedStore.snp.bottom).offset(6)
                } else {
                    $0.top.equalTo(myPageRecentViewedCell[i-1].snp.bottom).offset(11)
                }
                $0.trailing.equalTo(view.snp.trailing).offset(-10)
                $0.width.equalTo(Device.screenWidth * 0.85)
            }
        }
//
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(myPageRecentViewedCell[2].snp.bottom).offset(10)
            $0.leading.equalTo(myPageRecentViewedCell[2].snp.leading).offset(3)
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
        vc.storeData = self.recentViewed
     
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func favoriteButtonAction() {
        let vc = StoreListVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.contentMode = .FavoriteStore
        vc.storeData = self.favData
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func myReviewAction() {
        let vc = StoreListVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.contentMode = .UserFavoriteStore

        present(vc, animated: true, completion: nil)
    }
    
    @objc func reportStoreButtonAction() {
        let vc = ReportStoreVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
