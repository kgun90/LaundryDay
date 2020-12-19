//
//  JoinVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/17.
//

import UIKit

class JoinVC: UIViewController {

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
        label.text = "회원가입"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
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
        view.backgroundColor = .white
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(topViewLabel)
        view.addSubview(logoImage)
        
        
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
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Device.screenHeight * 0.137)
        }
    }
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
}
