//
//  ViewController.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/12.
//

import UIKit
import NMapsMap
import SnapKit
import BonsaiController
import CoreLocation

class ViewController: UIViewController, StoreDataDelegate {

    var mapView: NMFMapView!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    var storeDataManager = StoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        location()
        
        storeDataManager.delegate = self
        storeDataManager.requestStoreData()
    }

    func layout() {
        mapView = NMFMapView(frame: view.frame)
        
        view.addSubview(mapView)
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
    
    func updateStoreData(data: [StoreInformation]) {
        for i in 0 ..< data.count {
            let marker = NMFMarker()
            let geocoder = CLGeocoder()
//            let dataSource = NMFInfoWindowDefaultTextSource.data()
            
            geocoder.geocodeAddressString(data[i].address) { (placemarks, error) in
                guard
                    let placemakrs = placemarks,
                    let location = placemarks?.first?.location
                else {
                    return
                }
                marker.position = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                marker.width = 40
                marker.height = 40
                marker.iconImage = NMFOverlayImage(name: "Laundry_marker")
     
            }
            
        }
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
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
