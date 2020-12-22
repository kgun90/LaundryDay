//
//  StoreDetailMapVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/22.
//

import UIKit
import NMapsMap

class StoreDetailMapVC: UIViewController {
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
        label.text = "지도보기"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
    }()
    
    lazy var bottomView: UIView = {
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
    
    lazy var storeAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.regular, size: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "storeAddress"
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
    
    var nMapView: NMFMapView!
    var storeData: StoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addView()
        topViewLayout()
        bottomViewLayout()
        storeDetailMap(storeData!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        storeNameLabel.text = storeData?.name
        storeAddressLabel.text = storeData?.address
        storePhoneLabel.text = storeData?.phoneNum
    }

    @objc private func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addView() {
        view.backgroundColor = .mainBackground
        nMapView = NMFMapView(frame: self.view.frame)
        view.addSubview(nMapView)
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(topViewLabel)
        
        view.addSubview(bottomView)
        bottomView.addSubview(storeNameLabel)
        bottomView.addSubview(storeAddressLabel)
        bottomView.addSubview(phoneImage)
        bottomView.addSubview(storePhoneLabel)

    }
    
    func topViewLayout() {
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
    }
    
    func bottomViewLayout() {
        bottomView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.15)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(24)
        }
        
        storeAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.leading)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(2)
            $0.width.equalTo(Device.screenWidth * 0.8)
        }
        
        phoneImage.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.leading)
            $0.top.equalTo(storeAddressLabel.snp.bottom).offset(2)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        storePhoneLabel.snp.makeConstraints {
            $0.centerY.equalTo(phoneImage.snp.centerY)
            $0.leading.equalTo(phoneImage.snp.trailing).offset(3)
        }
        
    }

    func storeDetailMap(_ data: StoreData) {
        
        let marker = NMFMarker()
        let location = data.latLon
        
        marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
        marker.width = 30
        marker.height = 30
        marker.iconImage = NMFOverlayImage(name: "Laundry_marker")
        marker.mapView = self.nMapView
        nMapView.moveCamera(NMFCameraUpdate(scrollTo: marker.position))
        nMapView.zoomLevel = 15
        nMapView.allowsScrolling = false
//        nMapView.allowsZooming = false
    }
}
