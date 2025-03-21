//
//  LoginUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

import Foundation

protocol LoginUseCaseProtocol: AnyObject {
    func execute(credentials: AuthCredentials) async throws -> TokenResponse
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(credentials: AuthCredentials) async throws -> TokenResponse {
        return try await authRepository.login(credentials: credentials)
    }
}
