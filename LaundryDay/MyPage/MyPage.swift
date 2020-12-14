//
//  MyPage.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/14.
//

import UIKit

class MyPage: UIViewController {
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
    
    lazy var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.regular, size: 18)
        label.text = "로그인이 필요합니다."
        return label
    }()
    
    lazy var myReviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("내가 쓴 리뷰 >", for: .normal)
        
        return button
    }()
    
    lazy var reportStoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("세탁소 제보 >", for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xf5f9ff)
        layout()
    }

    func layout() {
        view.addSubview(topView)
        topView.addSubview(loginStatusLabel)
        topView.addSubview(profileImage)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(352)
            $0.height.equalTo(116)
        }
        loginStatusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        profileImage.snp.makeConstraints {
            $0.centerY.equalTo(loginStatusLabel.snp.centerY)
            $0.trailing.equalTo(loginStatusLabel.snp.leading).offset(-10)
        }
    }
}
