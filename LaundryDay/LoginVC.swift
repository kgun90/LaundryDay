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
    
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오로 로그인", for: .normal)
        button.titleLabel?.font = .BasicFont(.regular, size: 16)
        button.backgroundColor = UIColor(hex: 0xfcdc35)
        button.layer.cornerRadius = Device.screenHeight * 0.03
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var naverLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("네이버로 로그인", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .BasicFont(.regular, size: 16)
        button.backgroundColor = UIColor(hex: 0x44b65f)
        button.layer.cornerRadius = Device.screenHeight * 0.03
        return button
    }()
    
    lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("구글로 로그인", for: .normal)
        button.titleLabel?.font = .BasicFont(.regular, size: 16)
        button.backgroundColor = .white
        button.layer.cornerRadius = Device.screenHeight * 0.03
        button.setTitleColor(.black, for: .normal)
        return button
    }()
 
    lazy var emailLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일로 로그인", for: .normal)
        button.titleLabel?.font = .BasicFont(.regular, size: 16)
        button.backgroundColor = UIColor(hex: 0x004aad)
        button.layer.cornerRadius = Device.screenHeight * 0.03
        button.addTarget(self, action: #selector(emailLoginAction), for: .touchUpInside)
        return button
    }()

    lazy var joinLable: UILabel = {
        let label = UILabel()
        label.text = "런드리데이에 처음 오셨나요?"
        label.font = .BasicFont(.semiBold, size: 15)
        label.textColor = UIColor(hex: 0x7b6b6b)
        return label
    }()
    
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.titleBlue, for: .normal)
        button.titleLabel?.font = .BasicFont(.semiBold, size: 15)
        button.addTarget(self, action: #selector(joinAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
     
    }

    func layout() {
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(logoImage)
        view.addSubview(kakaoLoginButton)
        view.addSubview(naverLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(joinLable)
        view.addSubview(joinButton)
        
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(59)
        }
        
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Device.screenHeight * 0.137)
        }
        kakaoLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImage.snp.bottom).offset(Device.screenHeight * 0.11)
            $0.width.equalTo(Device.screenWidth * 0.76)
            $0.height.equalTo(Device.screenHeight * 0.06)
        }
        naverLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(6)
            $0.width.equalTo(Device.screenWidth * 0.76)
            $0.height.equalTo(Device.screenHeight * 0.06)
        }
        googleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(naverLoginButton.snp.bottom).offset(6)
            $0.width.equalTo(Device.screenWidth * 0.76)
            $0.height.equalTo(Device.screenHeight * 0.06)
        }
        emailLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(6)
            $0.width.equalTo(Device.screenWidth * 0.76)
            $0.height.equalTo(Device.screenHeight * 0.06)
        }
        
        joinLable.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Device.screenWidth * 0.21)
            $0.top.equalTo(emailLoginButton.snp.bottom).offset(Device.screenHeight * 0.11)
        }
        
        joinButton.snp.makeConstraints {
            $0.leading.equalTo(joinLable.snp.trailing).offset(3)
            $0.centerY.equalTo(joinLable.snp.centerY)
        }
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func emailLoginAction() {
        let vc = EmailLoginVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func joinAction() {
        let join = JoinVC()
        join.modalPresentationStyle = .overFullScreen
        present(join, animated: true, completion: nil)
    }

}
