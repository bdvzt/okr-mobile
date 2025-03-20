//
//  RegistrationViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import Foundation
import UIKit

protocol RegistrationViewModelProtocol: AnyObject {
    func register(firstName: String, lastName: String, email: String, password: String, group: Group) async
    var onRegisterSuccess: (() -> Void)? { get set }
}

final class RegistrationViewModel: RegistrationViewModelProtocol {

    private let registerUseCase: RegisterUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol

    var onRegisterSuccess: (() -> Void)?

    init(registerUseCase: RegisterUseCaseProtocol, logoutUseCase: LogoutUseCaseProtocol) {
        self.registerUseCase = registerUseCase
        self.logoutUseCase = logoutUseCase
    }

    func register(firstName: String, lastName: String, email: String, password: String, group: Group) async {
        let user = UserRegistration(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            group: group.rawValue
        )

        do {
            try await registerUseCase.execute(user: user)
            print("✅ Успешная регистрация")

            DispatchQueue.main.async {
                self.onRegisterSuccess?()
            }

            Task {
                do {
                    try await self.logoutUseCase.execute()
                    print("✅ Успешный выход после регистрации")

                    try await Task.sleep(nanoseconds: 2_500_000_000)

                    self.navigateToLogin()
                } catch {
                    print("❌ Ошибка выхода: \(error.localizedDescription)")
                }
            }
        } catch {
            print("❌ Ошибка регистрации: \(error.localizedDescription)")
        }
    }

    private func navigateToLogin() {
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
