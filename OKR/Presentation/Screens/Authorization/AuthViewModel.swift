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
    private let logoutUseCase: LogoutUseCaseProtocol

    var onLoginSuccess: (() -> Void)?
    var onRegister: (() -> Void)?

    init(loginUseCase: LoginUseCaseProtocol,
         getInfoUseCase: GetInfoUseCaseProtocol,
         logoutUseCase: LogoutUseCaseProtocol) {
        self.loginUseCase = loginUseCase
        self.getInfoUseCase = getInfoUseCase
        self.logoutUseCase = logoutUseCase
    }

    func login(email: String, password: String) async {
        let credentials = AuthCredentials(email: email, password: password)
        do {
            try await loginUseCase.execute(credentials: credentials)

            let userInfo = try await getInfoUseCase.execute()

            if userInfo.userRole == "USER" {
                DispatchQueue.main.async {
                    self.showPendingRoleAlert()
                }

                Task {
                    do {
                        try await self.logoutUseCase.execute()

                        try await Task.sleep(nanoseconds: 2_500_000_000)

                        self.navigateToLoginScreen()
                    } catch {
                        print("Ошибка выхода: \(error.localizedDescription)")
                    }
                }
            } else {
                DispatchQueue.main.async {
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

        alert.addAction(UIAlertAction(title: "OK", style: .default))

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
                    getInfoUseCase: GetInfoUseCase(userRepository: UserRepositoryImpl()),
                    logoutUseCase: LogoutUseCase(authRepository: AuthRepositoryImpl())
                ))

                window.rootViewController = authVC
                window.makeKeyAndVisible()
            }
        }
    }
}
