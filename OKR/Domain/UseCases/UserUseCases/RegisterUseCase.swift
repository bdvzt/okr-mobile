//
//  RegisterUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

import Foundation

protocol RegisterUseCaseProtocol: AnyObject {
    func execute(user: UserRegistration) async throws -> TokenResponse
}

final class RegisterUseCase: RegisterUseCaseProtocol {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(user: UserRegistration) async throws -> TokenResponse {
        return try await authRepository.register(user: user)
    }
}
