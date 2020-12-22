//
//  JoinVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/17.
//

import UIKit
import DLRadioButton

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
    @IBOutlet weak var generalUserRadioButton: DLRadioButton!
    @IBOutlet weak var businessOwnerRadioButton: DLRadioButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet var textFields: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        textFieldLayout()
        generalUserRadioButton.isSelected = true
        generalUserRadioButton.otherButtons.append(businessOwnerRadioButton)
        self.textFields.forEach {
            $0.delegate = self
        }
    }
    
    

    @IBAction func typeSelect(_ sender: DLRadioButton) {
        
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
    
    func textFieldLayout() {
        textFields.forEach {
            $0.borderStyle = .none
            let border = CALayer()
            border.frame = CGRect(x: 0, y: $0.frame.size.height - 1, width: $0.frame.width, height: 1)
            border.backgroundColor = UIColor.white.cgColor
            $0.layer.addSublayer(border)
  
        }
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension JoinVC: UITextFieldDelegate {
    // 사용자가 리턴키 입력시 true/false 를 validate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text)
        textFields.forEach {
            $0.endEditing(true)
        }
        return true
    }
    // 텍스트 필드에서 사용자의 수정이 완료되었을 때 true/false 를 validate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" { return true }
        else {
            textField.placeholder = "올바른 양식으로 입력 바랍니다."
            return false
        }
    }
    
    //텍스트 필드 수정을 끝냈을 때
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFields.forEach {
            $0.text = ""
        }
    }
}
