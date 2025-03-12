//
//  RegistrationViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import Foundation

protocol RegistrationViewModelProtocol: AnyObject {
    func register(firstName: String, lastName: String, email: String, password: String) async
}

final class RegistrationViewModel: RegistrationViewModelProtocol {

    private let registerUseCase: RegisterUseCaseProtocol

    init(registerUseCase: RegisterUseCaseProtocol) {
        self.registerUseCase = registerUseCase
    }

    func register(firstName: String, lastName: String, email: String, password: String) async {
        let user = UserRegistration(firstName: firstName, lastName: lastName, email: email, password: password)
        do {
            try await registerUseCase.execute(user: user)
            print("Успешная регистрация")
        } catch {
            print("Ошибка регистрации: \(error.localizedDescription)")
        }
    }
}
