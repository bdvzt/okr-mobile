//
//  UserRepositoryImpl.swift
//  OKR
//
//  Created by Zayata Budaeva on 20.03.2025.
//

import Foundation

final class UserRepositoryImpl: UserRepository {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getInfo() async throws -> UserDTO {
        let config = UserNetworkConfig.userInfo
        return try await networkService.request(config: config, authorized: true)
    }
}

