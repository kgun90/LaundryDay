//
//  NearStoreListVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/15.
//

import UIKit

class NearStoreListVC: UIViewController {
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
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var topViewLabel: UILabel = {
        let label = UILabel()
        label.text = "내근처 세탁소"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout() {
        view.backgroundColor = .mainBackground
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(searchButton)
        topView.addSubview(topViewLabel)
        
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
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-26)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        topViewLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    @objc private func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
