//
//  AuthViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import Foundation
import UIKit

protocol AuthViewModelProtocol: AnyObject {
    func login(email: String, password: String) async
    var onLoginSuccess: (() -> Void)? { get set }
    var onRegister: (() -> Void)? { get set }
}

final class AuthViewModel: AuthViewModelProtocol {

    private let loginUseCase: LoginUseCaseProtocol
    private let getInfoUseCase: GetInfoUseCaseProtocol

    var onLoginSuccess: (() -> Void)?
    var onRegister: (() -> Void)?

    init(loginUseCase: LoginUseCaseProtocol, getInfoUseCase: GetInfoUseCaseProtocol) {
        self.loginUseCase = loginUseCase
        self.getInfoUseCase = getInfoUseCase
    }

    func login(email: String, password: String) async {
        let credentials = AuthCredentials(email: email, password: password)
        do {
            try await loginUseCase.execute(credentials: credentials)

            let userInfo = try await getInfoUseCase.execute()

            DispatchQueue.main.async {
                if userInfo.userRole == "USER" {
                    self.showPendingRoleAlert()
                } else {
                    self.onLoginSuccess?()
                }
            }
        } catch {
            print("Ошибка входа: \(error.localizedDescription)")
        }
    }

    private func showPendingRoleAlert() {
        let alert = UIAlertController(
            title: "Доступ ограничен",
            message: "Ваша роль ещё не подтверждена. Дождитесь подтверждения администратора.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigateToLoginScreen()
        }))

        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootVC = window.rootViewController {
                rootVC.present(alert, animated: true)
            }
        }
    }

    private func navigateToLoginScreen() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first {
                let authVC = AuthViewController(viewModel: AuthViewModel(
                    loginUseCase: LoginUseCase(authRepository: AuthRepositoryImpl()),
                    getInfoUseCase: GetInfoUseCase(userRepository: UserRepositoryImpl()) 
                ))

                window.rootViewController = authVC
                window.makeKeyAndVisible()
            }
        }
    }
}
