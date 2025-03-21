//
//  GetInfoUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 20.03.2025.
//

import Foundation

protocol GetInfoUseCaseProtocol: AnyObject {
    func execute() async throws -> UserDTO
}

final class GetInfoUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension GetInfoUseCase: GetInfoUseCaseProtocol {
    func execute() async throws -> UserDTO {
        try await userRepository.getInfo()
    }
}

