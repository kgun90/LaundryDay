//
//  WriteReviewVCViewController.swift
//  LaundryDay
//
//  Created by Geon Kang on 2021/01/08.
//

import UIKit
import SnapKit
import Cosmos
import Firebase

class WriteReviewVC: UIViewController {
    // MARK: - UI Init
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
        label.text = "리뷰 쓰기"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
    }()
    
    lazy var storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.semiBold, size: 16)
        label.textColor = .titleBlue
        label.text = "세탁소 이름"
        return label
    }()
    
    lazy var submitReviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .BasicFont(.semiBold, size: 17)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return button
    }()

    lazy var reviewContentTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.font = .BasicFont(.regular, size: 18)
        tv.textColor = .black
        return tv
    }()
    
    lazy var typeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.regular, size: 12)
        label.textColor = UIColor(hex: 0x7c7c7c)
        label.text = "0/400"
        
        return label
    }()
    
    lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .BasicFont(.regular, size: 12)
        label.textColor = UIColor(hex: 0x7c7c7c)
        label.text = "욕설이나 비방등의 부적절한 내용은 삭제될 수 있습니다."
        return label
    }()
    
    var storeName = ""
    var storeData: StoreData?
    let cosmosView = CosmosView()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewContentTextView.delegate = self
        storeNameLabel.text = storeName
        layout()
        
        cosmosView.rating = 5
        cosmosView.tintColor = UIColor(hex: 0xfdf74e)
        cosmosView.settings.fillMode = .half
        cosmosView.didFinishTouchingCosmos = { rating in
            print(rating)
        }
    }
    
    func layout() {
        view.backgroundColor = .mainBackground
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(topViewLabel)
        
        view.addSubview(cosmosView)
        
        view.addSubview(storeNameLabel)
      
        view.addSubview(reviewContentTextView)
        view.addSubview(typeCountLabel)
        view.addSubview(warningLabel)
        view.addSubview(submitReviewButton)
        
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
        
        cosmosView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(125)
            $0.height.equalTo(50)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(15)
        }
 
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(31)
            $0.centerX.equalToSuperview()
        }
        
        submitReviewButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.08)
            $0.bottom.equalToSuperview()
        }
        
        reviewContentTextView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(Device.screenHeight * 0.13)
            $0.bottom.equalTo(submitReviewButton.snp.top).offset(Device.screenHeight * -0.06)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        typeCountLabel.snp.makeConstraints {
            $0.top.equalTo(reviewContentTextView.snp.bottom).offset(6)
            $0.trailing.equalTo(reviewContentTextView.snp.trailing).offset(-6)
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(reviewContentTextView.snp.bottom).offset(6)
            $0.leading.equalTo(reviewContentTextView.snp.leading).offset(6)
        }
        
    }
    
    @objc private func backAction() {
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        self.presentAlert(
            title: "나가기",
            message: "작성중인 리뷰가 있습니다. 종료하시겠습니까?",
            isCancelActionIncluded: false,
            with: ok, cancel
        )
    }
    
    @objc private func submitAction() {
        let id = K.fs.collection(K.Table.laundry).document(storeData?.id ?? "")
        let writer = K.fs.collection(K.Table.members).document(Auth.auth().currentUser?.email ?? "")
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            if let reviewContent = self.reviewContentTextView.text {
                K.fs.collection(K.Table.review).addDocument(data: [
                    "laundry" : id,
                    "writer" : writer,
                    "time" : Date(),
                    "content" :reviewContent,
                    "rate" : self.cosmosView.rating
                ])
            }
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.presentAlert(
            title: "작성하기",
            message: "리뷰를 등록하시겠습니까?",
            isCancelActionIncluded: false,
            with: ok, cancel
        )
    }
    
}

extension WriteReviewVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        if textView.text.count > 0 {
            submitReviewButton.isEnabled = true
            submitReviewButton.backgroundColor = .titleBlue
        } else {
            submitReviewButton.isEnabled = false
            submitReviewButton.backgroundColor = .lightGray
        }
        typeCountLabel.text = "\(textView.text.count) / 400"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 401
        // 입력 글자 수 제한
    }
}
