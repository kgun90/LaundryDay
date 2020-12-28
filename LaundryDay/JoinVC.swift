//
//  JoinVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/17.
//

import UIKit
import DLRadioButton
import SwiftValidator
import FirebaseAuth

struct LoginData {
    let id: String
    let password: String
    let nickname: String
}

class JoinVC: UIViewController{

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
    
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .BasicFont(.semiBold, size: 17)
        button.backgroundColor = .titleBlue
        button.addTarget(self, action: #selector(joinAction), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var generalUserRadioButton: DLRadioButton!
    @IBOutlet weak var businessOwnerRadioButton: DLRadioButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var emailDescriptionLabel: UILabel!
    @IBOutlet weak var passwordDescriptionLabel: UILabel!
    @IBOutlet weak var passwordCheckDescriptionLabel: UILabel!
    @IBOutlet var textFields: [UITextField]!
    
    var loginData: LoginData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        textFieldLayout()
     
        generalUserRadioButton.isSelected = true
        generalUserRadioButton.otherButtons.append(businessOwnerRadioButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
  
    @objc func keyboardWillShow(note: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        self.view.frame.origin.y = 0
    }

    @IBAction func typeSelect(_ sender: DLRadioButton) {
        
    }
    
    @objc func joinAction() {
        if let email = emailTextField.text, let password = passwordTextField.text{
            //  Optional Chaning으로 Textfield의 Text 값을 Optional String 에서 String으로 사용할 수 있게 한다.
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    let vc = ViewController()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = vc
                        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                    } else {
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func layout() {
        view.backgroundColor = .white
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(topViewLabel)
        view.addSubview(logoImage)
        view.addSubview(joinButton)
        
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
            $0.top.equalToSuperview().offset(Device.screenHeight * 0.12)
        }
        
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Device.screenHeight * 0.1)
        }
        
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension JoinVC: UITextFieldDelegate {
    // 사용자가 리턴키 입력시 true/false 를 validate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 텍스트 필드에서 사용자의 수정이 완료되었을 때 true/false 를 validate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            switch textField {
            case emailTextField:
                if emailTextField.text?.validateEmail() ?? false {
                    emailDescriptionLabel.textColor = .green
                    emailDescriptionLabel.text = "올바른 양식입니다"
                } else {
                    emailDescriptionLabel.textColor = .red
                    emailDescriptionLabel.text = "올바른 양식으로 입력해주세요"
                }
            case passwordTextField:
                if passwordTextField.text?.validatePassword() ?? false {
                    passwordDescriptionLabel.textColor = .green
                    passwordDescriptionLabel.text = "안전한 패스워드 입니다"
                } else {
                    passwordDescriptionLabel.textColor = .red
                    passwordDescriptionLabel.text = "올바른 양식으로 입력해주세요"
                }
            case passwordCheckTextField:
                if passwordCheckTextField.text == passwordTextField.text {
                    passwordCheckDescriptionLabel.textColor = .green
                    passwordCheckDescriptionLabel.text = "패스워드가 일치합니다"
                } else {
                    passwordCheckDescriptionLabel.textColor = .red
                    passwordCheckDescriptionLabel.text = "패스워드가 일치하지 않습니다"
                }
            default:
                print("HI")
            }
            return true
        }
        else {
            textField.placeholder = "항목이 입력되지 않았습니다"
            return true
        }
   
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    //텍스트 필드 수정을 끝냈을 때
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        
    }
}
