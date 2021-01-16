//
//  ReportStoreVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/16.
//

import UIKit
import DLRadioButton
import Firebase
import CoreLocation

class ReportStoreVC: UIViewController, UITextFieldDelegate {
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)).cgPath
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowColor = UIColor.black.cgColor

        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
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
        label.text = "세탁소 제보"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("제보하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .BasicFont(.semiBold, size: 17)
        button.backgroundColor = .titleBlue
        button.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var selfLaundryTypeRadioButton: DLRadioButton!
    @IBOutlet weak var generalLaundryTypeRadioButton: DLRadioButton!
    @IBOutlet weak var agreementRadioButton: DLRadioButton!
    
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var storePhoneTextField: UITextField!
    @IBOutlet weak var storeAddressTextField: UITextField!

    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiobuttonSet()
        layout()
        
        // Do any additional setup after loading the view.
    }
    
    func radiobuttonSet() {
        // 일반사용자 항목이 선택되어 있는 상태를 Default로 설정한다.
        selfLaundryTypeRadioButton.isSelected = true
        selfLaundryTypeRadioButton.tag = 1
        generalLaundryTypeRadioButton.tag = 2
        selfLaundryTypeRadioButton.otherButtons.append(generalLaundryTypeRadioButton)
        
        agreementRadioButton.isIconSquare = true
      
        selfLaundryTypeRadioButton.addTarget(self, action: #selector(radioButtonAction), for: .touchUpInside)
        generalLaundryTypeRadioButton.addTarget(self, action: #selector(radioButtonAction), for: .touchUpInside)
        agreementRadioButton.addTarget(self, action: #selector(radioButtonAction), for: .touchUpInside)
      
    }

    @objc func radioButtonAction(_ sender: DLRadioButton) {
        print(sender.tag)
    }

    func layout() {
        view.backgroundColor = .white
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(topViewLabel)
        view.addSubview(submitButton)
        
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
         
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.1)
        }
        textFieldLayout()
    }
    
    func textFieldLayout() {
        textFields.forEach {
            $0.borderStyle = .none
            let border = CALayer()
            border.frame = CGRect(x: 0, y: $0.frame.size.height - 1, width: $0.frame.width, height: 1)
            border.backgroundColor = UIColor.black.cgColor
            $0.layer.addSublayer(border)
            $0.delegate = self
        }
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func submitButtonAction() {
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            self.submitReport()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.presentAlert(
            title: "세탁소 제보",
            message: "진행하시겠습니까?",
            with: ok, cancel
        )
    }
    
    func submitReport() {
        if let writer = Auth.auth().currentUser?.email,
           let name = storeNameTextField.text,
           let address = storeAddressTextField.text,
           let number = storePhoneTextField.text {
            let geocoder = CLGeocoder()
//            let geo = G
            geocoder.geocodeAddressString(address) { (placemark, error) in
                guard
                    let mark = placemark?.first?.location?.coordinate
                else {
                    return
                }
                K.fs.collection(K.Table.laundry).addDocument(data:[
                    "name": name,
                    "type": "0001",
                    "address": address,
                    "address_array": address.components(separatedBy: " "),
                    "latLng": GeoPoint(latitude: mark.latitude, longitude: mark.longitude),
                    "writer": K.fs.collection(K.Table.members).document(writer),
                    "time": Date(),
                    "registered": false,
                    "number": number
                ]
                )
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}
