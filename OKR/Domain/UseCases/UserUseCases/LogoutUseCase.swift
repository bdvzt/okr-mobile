//
//  LogoutUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

import Foundation

protocol LogoutUseCaseProtocol: AnyObject {
    func execute() async throws
}

final class LogoutUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension LogoutUseCase: LogoutUseCaseProtocol {
    func execute() async throws {
        try await authRepository.logout()
    }
}

