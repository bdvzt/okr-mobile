//
//  RegisterUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

import Foundation

protocol RegisterUseCaseProtocol: AnyObject {
    func execute(user: UserRegistration) async throws
}

final class RegisterUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension RegisterUseCase: RegisterUseCaseProtocol {
    func execute(user: UserRegistration) async throws {
        try await authRepository.register(user: user)
    }
}
