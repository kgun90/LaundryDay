//
//  LoginVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/16.
//

import UIKit

class LoginVC: UIViewController {
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        return button
    }()

    lazy var logoImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Logo_Large")
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
     
    }
    
    func layout() {
        view.addSubview(backButton)
        view.addSubview(logoImage)
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(59)
        }
        
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Device.screenHeight * 0.137)
        }
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
}
