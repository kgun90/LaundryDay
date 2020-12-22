//
//  String.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/22.
//

import UIKit

extension String {
    // E-mail address validation
    func validateEmail() -> Bool {
           let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
           
           let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return predicate.evaluate(with: self)
       }
       
       // Password validation
    func validatePassword() -> Bool {
           let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#$%^&*()?]).{8,16}$"
           
           let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
           return predicate.evaluate(with: self)
       }
       
}
