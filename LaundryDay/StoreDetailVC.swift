//
//  StoreDetailVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/18.
//

import UIKit
import NMapsMap
import RealmSwift


class StoreDetailVC: UIViewController {
    enum buttonStatus {
        case on
        case off
    }
 
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
    
    lazy var topViewLabel: UILabel = {
        let label = UILabel()
        label.text = "세탁소 정보"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
    }()
    
    lazy var storeInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.semiBold, size: 16)
        label.textColor = .titleBlue
        label.text = "StoreName"
        return label
    }()
    
    lazy var storeTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.regular, size: 10)
        label.textColor = UIColor(hex: 0xb5b5b5)
        label.text = "StoreType"
        return label
    }()
    
    lazy var phoneImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "phone")
        iv.tintColor = UIColor(hex: 0x707070)
        return iv
    }()
    
    lazy var storePhoneLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.regular, size: 13)
        label.textColor = .black
        label.text = "00-000-0000"
        
        return label
    }()
    
    lazy var storePhoneButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.titleLabel?.font = .BasicFont(.regular, size: 13)
        button.tintColor = .black
        button.addTarget(self, action: #selector(dialStore), for: .touchUpInside)
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = UIColor(hex: 0xbaadb0)
        button.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        return button
    }()
    
    lazy var mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var addressImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "mappin.and.ellipse")
        iv.tintColor = UIColor(hex: 0x707070)
        return iv
    }()
    
    lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.semiBold, size: 14)
        label.textColor = .titleBlue
        label.text = "주소"
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.regular, size: 14)
        label.textColor = .black
        label.text = "StoreAddress"
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    lazy var writeReviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("리뷰작성하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .BasicFont(.semiBold, size: 17)
        button.backgroundColor = .titleBlue
        button.addTarget(self, action: #selector(writeAction), for: .touchUpInside)
        return button
    }()
    
    lazy var reviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 리뷰"
        label.font = .BasicFont(.semiBold, size: 14)
        label.textColor = .titleBlue
        return label
    }()
    
    lazy var rateAvgImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = UIColor(hex: 0xfdf74e)
        return iv
    }()
    
    lazy var rateAvgLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.bold, size: 13)
        label.text = "avg"
        label.textColor = .black
        return label
    }()
    
    lazy var reviewTableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    
    var nmapView: NMFMapView!
    var storeDetailData: StoreData?
    var updateID: Int?
    let realm = try! Realm()
    var favoriteButtonStatus: buttonStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        layout()
        storeDetailMap(storeDetailData!)
        addMapViewGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        storeNameLabel.text = storeDetailData?.name
//        storePhoneLabel.text = storeDetailData?.phoneNum
        storePhoneButton.setTitle(storeDetailData?.phoneNum, for: .normal)
        addressLabel.text = storeDetailData?.address
        addRecentData()
        favoriteButtonLayout()

    }
     
    func addRecentData() {
        let storeData = RecentViewedData()

        storeData.id = storeDetailData!.id
        storeData.date = Date()
 
        try! realm.write{
            realm.add(storeData, update: .modified)
        }
    }
    
    func reviewTableSet() {
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.separatorColor = .clear
        reviewTableView.backgroundColor = .mainBackground
        
        reviewTableView.register(UINib(nibName: "ReviewCustomCell", bundle: nil), forCellReuseIdentifier: "ReviewCustomCell")
    }
    
    func storeDetailMap(_ data: StoreData) {
        
        let marker = NMFMarker()
        let location = data.latLon
        
        marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
        marker.width = 30
        marker.height = 30
        marker.iconImage = NMFOverlayImage(name: "Laundry_marker")
        marker.mapView = self.nmapView
        nmapView.moveCamera(NMFCameraUpdate(scrollTo: marker.position))
        
        nmapView.allowsScrolling = false
        nmapView.allowsZooming = false
    }
    
    @objc private func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dialStore() {
        if let phoneNumber = storeDetailData?.phoneNum {
            if let url = URL(string: "tel://" + phoneNumber) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func favoriteButtonLayout() {
        if favoriteButtonStatus == .off {
            favoriteButton.tintColor = .gray
        } else if favoriteButtonStatus == .on {
            favoriteButton.tintColor = .red
        }
    }
    
    @objc func favoriteAction() {
        if favoriteButtonStatus == .off {
            favoriteControl()
            favoriteButtonStatus = .on
            favoriteButton.tintColor = .red
            
        } else if favoriteButtonStatus == .on {
            favoriteControl()
            favoriteButtonStatus = .off
            favoriteButton.tintColor = .gray
        }
    }
    
    func favoriteControl() {
        let favoriteData = FavoriteData()
        let id = storeDetailData!.id
        let objectToDelete = realm.objects(FavoriteData.self).filter("id == %@", id)
        
        favoriteData.id = id
        
        try! realm.write{
            if favoriteButtonStatus == .off {
                realm.add(favoriteData, update: .modified)
            } else if favoriteButtonStatus == .on {
                realm.delete(objectToDelete)
            }
        }
    }
    
    func addMapViewGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        singleTapGesture.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(singleTapGesture)
    }
    
    @objc func tapAction() {
        let vc = StoreDetailMapVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.storeData = self.storeDetailData
        present(vc, animated: true, completion: nil)
    }
    
    @objc func writeAction() {
        let vc = WriteReviewVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.storeName = storeNameLabel.text ?? ""
        vc.storeData = self.storeDetailData
        present(vc, animated: true, completion: nil)
    }
// MARK: - View Layout
    func addView() {
        view.backgroundColor = .mainBackground
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(topViewLabel)
        
        view.addSubview(storeInfoView)
        storeInfoView.addSubview(storeNameLabel)
        storeInfoView.addSubview(storeTypeLabel)
        storeInfoView.addSubview(phoneImage)
        storeInfoView.addSubview(storePhoneButton)
//        storeInfoView.addSubview(storePhoneLabel)
        storeInfoView.addSubview(favoriteButton)
        
        view.addSubview(mapView)
        nmapView = NMFMapView()
        mapView.addSubview(addressImage)
        mapView.addSubview(addressTitleLabel)
        mapView.addSubview(addressLabel)
        mapView.addSubview(nmapView)
        
        view.addSubview(writeReviewButton)
        view.addSubview(reviewTitleLabel)
        view.addSubview(rateAvgLabel)
        view.addSubview(rateAvgImage)
        view.addSubview(reviewTableView)
    }
    
    
    func layout() {
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
    
        topViewLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        writeReviewButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.08)
            $0.bottom.equalToSuperview()
        }
        
        storeInfoLayout()
        mapViewLayout()
        reviewTableSet()
        reviewListLayout()
    }
    
    func storeInfoLayout() {
        storeInfoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(3)
            $0.width.equalTo(Device.screenWidth)
            $0.height.equalTo(Device.screenHeight * 0.1)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26)
            $0.top.equalToSuperview().offset(17)
        }
        
        storeTypeLabel.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(2)
            $0.bottom.equalTo(storeNameLabel.snp.bottom)
        }
        
        phoneImage.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.leading)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(3)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        storePhoneButton.snp.makeConstraints {
            $0.leading.equalTo(phoneImage.snp.trailing).offset(3)
            $0.centerY.equalTo(phoneImage.snp.centerY)
        }
        
//        storePhoneLabel.snp.makeConstraints {
//            $0.leading.equalTo(storePhoneButton.snp.trailing).offset(3)
//            $0.centerY.equalTo(storePhoneButton.snp.centerY)
//        }
        
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-38)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
    }
    
    func mapViewLayout() {
        mapView.snp.makeConstraints {
            $0.top.equalTo(storeInfoView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.3)
        }
        
        addressImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(23)
            $0.width.equalTo(21)
            $0.height.equalTo(21)
        }
        
        addressTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(addressImage.snp.centerY)
            $0.leading.equalTo(addressImage.snp.trailing).offset(1)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(addressImage.snp.bottom).offset(2)
            $0.leading.equalTo(addressImage.snp.leading)
            $0.width.equalTo(Device.screenWidth * 0.8)
        }
        
        nmapView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(addressLabel.snp.bottom).offset(2)
        }
    }
    

    
    func reviewListLayout() {
        reviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(25)
        }
        
        rateAvgLabel.snp.makeConstraints {
            $0.centerY.equalTo(reviewTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        rateAvgImage.snp.makeConstraints {
            $0.centerY.equalTo(reviewTitleLabel.snp.centerY)
            $0.trailing.equalTo(rateAvgLabel.snp.leading).offset(-2)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        
        reviewTableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(3)
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.3)
        }
    }
}

extension StoreDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCustomCell", for: indexPath as IndexPath) as! ReviewCustomCell
    
        return cell
    }
    
    
}
