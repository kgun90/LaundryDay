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
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        
        return button
    }()
    
    lazy var reportStoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("세탁소 제보 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    lazy var recentViewedStore: UIButton = {
        let button = UIButton()
        button.setTitle("최근 본 세탁소", for: .normal)
        button.tintColor = UIColor(hex: 0x004aad)
        button.setTitleColor(UIColor(hex: 0x004aad), for: .normal)
        return button
    }()
    
    let customView = MyPageCustomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xf5f9ff)
        layout()
    }

    func layout() {
        view.addSubview(topView)
        topView.addSubview(loginStatusLabel)
        topView.addSubview(profileImage)
        topView.addSubview(myReviewButton)
        topView.addSubview(reportStoreButton)
        view.addSubview(recentViewedStore)
        view.addSubview(customView)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(Device.screenWidth * 0.9)
            $0.height.equalTo(116)
        }
        loginStatusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        profileImage.snp.makeConstraints {
            $0.centerY.equalTo(loginStatusLabel.snp.centerY)
            $0.trailing.equalTo(loginStatusLabel.snp.leading).offset(-10)
        }
        
        myReviewButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo((Device.screenWidth * 0.9) * 0.5)
            $0.height.equalTo(40)
        }
        reportStoreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo((Device.screenWidth * 0.9) * 0.5)
            $0.height.equalTo(40)
        }
        
        recentViewedStore.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(30)
            $0.leading.equalTo(view.snp.leading).offset(37)
        }
        customView.snp.makeConstraints {
            $0.top.equalTo(recentViewedStore.snp.bottom).offset(6)
            $0.trailing.equalTo(view.snp.trailing).offset(14)
            $0.width.equalTo(352)
        }
    }
}
