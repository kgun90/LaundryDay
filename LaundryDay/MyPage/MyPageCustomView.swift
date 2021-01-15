//
//  MyPageCustomView.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/14.
//

import UIKit
import RealmSwift

class MyPageCustomView: UIView {
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDialView: UIView!
    @IBOutlet weak var storeRouteView: UIView!
    @IBOutlet var myPageCustomView: UIView!
    
    
    var storeData: StoreData?
    let realm = try! Realm()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit(){
        guard let view = loadView(nibName: "MyPageCustomView") else { return }
        
        view.frame = self.bounds
                
        addViewTapGesture()
        self.addSubview(view)
    }
    
    func addViewTapGesture() {
        print("view Tapped")
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        singleTapGesture.numberOfTouchesRequired = 1
        myPageCustomView.addGestureRecognizer(singleTapGesture)
    }
    
    @objc func tapAction() {
        let vc = StoreDetailVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.storeDetailData = storeData
        let currentController = self.getCurrentViewController()
        currentController?.present(vc, animated: true, completion: nil)
        
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while (currentController.presentedViewController != nil) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
}
