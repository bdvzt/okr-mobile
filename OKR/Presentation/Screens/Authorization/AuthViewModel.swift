//
//  AuthViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import Foundation

protocol AuthViewModelProtocol: AnyObject {
    func login(email: String, password: String) async
    var onLoginSuccess: (() -> Void)? { get set }
    var onRegister: (() -> Void)? { get set }
}

final class AuthViewModel: AuthViewModelProtocol {

    private let loginUseCase: LoginUseCaseProtocol

    var onLoginSuccess: (() -> Void)?
    var onRegister: (() -> Void)?

    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }

    func login(email: String, password: String) async {
        let credentials = AuthCredentials(email: email, password: password)
        do {
            try await loginUseCase.execute(credentials: credentials)
            DispatchQueue.main.async {
                self.onLoginSuccess?()
            }
        } catch {
            print("Ошибка входа: \(error.localizedDescription)")
        }
    }
}
