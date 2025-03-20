//
//  RegistrationViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import Foundation

protocol RegistrationViewModelProtocol: AnyObject {
    func register(firstName: String, lastName: String, email: String, password: String, group: Group) async
    var onRegisterSuccess: (() -> Void)? { get set }
}

final class RegistrationViewModel: RegistrationViewModelProtocol {

    private let registerUseCase: RegisterUseCaseProtocol
    var onRegisterSuccess: (() -> Void)?

    init(registerUseCase: RegisterUseCaseProtocol) {
        self.registerUseCase = registerUseCase
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
        } catch {
            print("❌ Ошибка регистрации: \(error.localizedDescription)")
        }
    }
}
