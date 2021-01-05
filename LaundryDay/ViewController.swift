//
//  ViewController.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/12.
//

import UIKit
import NMapsMap
import SnapKit
import DLRadioButton
import BonsaiController
import CoreLocation
import RealmSwift

private enum TransitionType {
    case none
    case bottom
    case slide
    case menu
}

class ViewController: UIViewController, StoreDataDelegate {
      
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var myPageButton: UIButton = {
        let button  = UIButton()
        button.setImage(UIImage(named: "MyPage"), for: .normal)
        button.addTarget(self, action: #selector(myPageAction), for: .touchUpInside)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "List"), for: .normal)
        button.addTarget(self, action: #selector(nearStoreListAction), for: .touchUpInside)
        return button
    }()
    
    lazy var topViewLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Logo_TopView")
        return iv
    }()
    
    lazy var storeTypeSegment: UISegmentedControl = {
        let segItem = ["셀프", "세탁소"]
        let seg = UISegmentedControl(items: segItem)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: 0x7ccaff)], for: .normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: 0x000000)], for: .selected)
        
        seg.tintColor = UIColor(hex: 0x7ccaff)
        seg.backgroundColor = UIColor(hex: 0x004aad)
        
        seg.selectedSegmentIndex = 0
        
        return seg
    }()
    
    private var transitionType: TransitionType = .none

    var mapView: NMFMapView!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    var storeDataManager = StoreDataManager()
    var bottomView = BottomCustomView()
    var storeData: [StoreData]?
    var realm = try! Realm()
    var favoriteData: Results<FavoriteData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        location()
    
        storeDataManager.delegate = self
    }

    func requestData() {
        let geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(currentLocation) { (placemark, error) in
            guard
                let mark = placemark,
                let location = mark.first?.locality
            else {
                return
            }
          
            self.storeDataManager.requestFSData(location)
        }
    }

    
    func layout() {
        mapView = NMFMapView(frame: view.frame)
        
        view.addSubview(mapView)
        view.addSubview(topView)
        topView.addSubview(topViewLogo)
        topView.addSubview(myPageButton)
        topView.addSubview(listButton)
        topView.addSubview(storeTypeSegment)
        
        topView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(Device.screenWidth)
            $0.height.equalTo(127)
        }
        topViewLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        myPageButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(26)
        }
        listButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-22)
        }
        storeTypeSegment.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topViewLogo.snp.bottom).offset(12)
        }
        
    }
    
    func location() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            print("enabled")
            locationManager.requestLocation()
        }
    }
    
   
    func getStoreData(data: [StoreData]) {
        self.storeData = data
        for i in 0 ..< data.count {
            
            let marker = NMFMarker()
            let location = data[i].latLon
           
            marker.position = NMGLatLng(lat: location.latitude ,lng: location.longitude)
            marker.width = 40
            marker.height = 40
            marker.iconImage = NMFOverlayImage(name: "Laundry_marker")
            marker.mapView = self.mapView
    
            let handler = { (overlay: NMFOverlay) -> Bool in
                if let _ = overlay as? NMFMarker {
                    let distance = NMGLatLng(from: self.currentLocation.coordinate).distance(to: marker.position)

                    self.showBtmView(data[i], distance)
                }
                return true
            }
            marker.touchHandler = handler
            }
    }
    
    func showBtmView(_ data: StoreData, _ distance: CLLocationDistance) {
        let btmView = BottomCustomView()
        
        btmView.transitioningDelegate = self
        btmView.modalPresentationStyle = .custom
        transitionType = .bottom
        
        btmView.storeDistance = String(format: "%.1fkm", distance/1000.0)
        btmView.bottomViewData = data
     
        if realm.objects(FavoriteData.self).filter("id == %@", data.id).first != nil {
            btmView.favoriteButtonStatus = .on
            print("on")
        } else {
            btmView.favoriteButtonStatus = .off
            print("off")
        }
       
        
        present(btmView, animated: true, completion: nil)
    }
    
    @objc func myPageAction() {
        let myPage = MyPage()
        
        myPage.transitioningDelegate = self
        myPage.modalPresentationStyle = .custom
        transitionType = .menu
        
        present(myPage, animated: true, completion: nil)
    }
    
    @objc func nearStoreListAction() {
        let listPage = StoreListVC()
        
        listPage.transitioningDelegate = self
        listPage.modalPresentationStyle = .custom
        transitionType = .slide
        listPage.contentMode = .NearStore
        listPage.storeData = self.storeData
    
    
        present(listPage, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            self.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lon)))
            self.currentLocation = location
            self.requestData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}

extension ViewController: BonsaiControllerDelegate {
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
         
        switch transitionType {
        case .none:
            return CGRect(origin: .zero, size: containerViewFrame.size)
        case .bottom:
           return CGRect(origin: CGPoint(x: 0, y: 660), size: CGSize(width: containerViewFrame.width, height: 152 ))
        case .menu:
           return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height * 0.11), size: CGSize(width: Device.screenWidth * 0.9, height: containerViewFrame.height ))
        case .slide:
            return  CGRect(origin: .zero, size: containerViewFrame.size)
           
        }
        
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        let blurEffectStyle = UIBlurEffect.Style.systemMaterialDark
        switch transitionType {
        case .none:
            return BonsaiController(fromDirection: .bottom, blurEffectStyle: blurEffectStyle, presentedViewController: presented, delegate: self)
        case .bottom:
            return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor.clear, presentedViewController: presented, delegate: self)
        case .menu:
            return BonsaiController(fromDirection: .left, blurEffectStyle: blurEffectStyle, presentedViewController: presented, delegate: self)
        case .slide:
            return BonsaiController(fromDirection: .right, blurEffectStyle: blurEffectStyle, presentedViewController: presented, delegate: self)
        }
    }
}
