//
//  LoginUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

import Foundation

protocol LoginUseCaseProtocol: AnyObject {
    func execute(credentials: AuthCredentials) async throws
}

final class LoginUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension LoginUseCase: LoginUseCaseProtocol {
    func execute(credentials: AuthCredentials) async throws {
        try await authRepository.login(credentials: credentials)
    }
}

