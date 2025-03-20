//
//  Validator.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

import Foundation

final class Validator {

    static func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[А-ЯЁ][а-яё]{1,49}$"
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }

    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!?\\.])[A-Za-z0-9!?\\.]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
