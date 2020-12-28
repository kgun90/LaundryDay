//
//  EmailLoginVC.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/23.
//

import UIKit
import Firebase

class EmailLoginVC: UIViewController {

    lazy var logoImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Logo_Large")
        return iv
    }()
    
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
        label.text = "이메일로 로그인"
        label.textColor = .titleBlue
        label.font = .BasicFont(.semiBold, size: 18)
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .black
        label.font = .BasicFont(.medium, size: 14)
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .default
        tf.font = .BasicFont(.regular, size: 14)
        tf.textColor = .black
        tf.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: tf.frame.size.height - 1, width: tf.frame.width, height: 1)
        border.backgroundColor = UIColor.black.cgColor
        tf.layer.addSublayer(border)
   
        return tf
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "패스워드"
        label.textColor = .black
        label.font = .BasicFont(.medium, size: 14)
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = .BasicFont(.regular, size: 14)
        tf.textColor = .black
        tf.borderStyle = .none
       
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .BasicFont(.semiBold, size: 16)
        button.tintColor = .white
        button.backgroundColor = .titleBlue
        button.layer.cornerRadius = Device.screenHeight * 0.03
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        textFieldLayout()
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
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func loginAction() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    let vc = ViewController()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = vc
                        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                    } else {
                        vc.modalPresentationStyle = .overFullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // TextField 활성화 중 다른영역 터치 했을 때 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func layout() {
        view.backgroundColor = .white
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(topViewLabel)
        view.addSubview(logoImage)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
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
            $0.top.equalToSuperview().offset(Device.screenHeight * 0.13)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(Device.screenHeight * 0.20)
            $0.leading.equalToSuperview().offset(Device.screenWidth * 0.1)
        }
        emailTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Device.screenWidth * 0.8)
            $0.top.equalTo(emailLabel.snp.bottom).offset(3)
            $0.height.equalTo(35)
        }
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(Device.screenHeight * 0.1)
            $0.leading.equalToSuperview().offset(Device.screenWidth * 0.1)
        }
        passwordTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Device.screenWidth * 0.8)
            $0.top.equalTo(passwordLabel.snp.bottom).offset(3)
            $0.height.equalTo(35)
        }
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(Device.screenHeight * -0.3)
            $0.width.equalTo(Device.screenWidth * 0.76)
            $0.height.equalTo(Device.screenHeight * 0.06)
        }
    }
    func textFieldLayout() {
       
        let border = CALayer()
        border.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - 1, width: passwordTextField.frame.width, height: 1)
        border.backgroundColor = UIColor.black.cgColor
        passwordTextField.layer.addSublayer(border)

        
    }
}
