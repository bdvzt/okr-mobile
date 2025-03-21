//
//  AuthRepositoryImpl.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let tokenStorage = TokenStorage()
    private let networkService: NetworkServiceProtocol = NetworkService()

    func register(user: UserRegistration) async throws -> TokenResponse {
        let data = try JSONEncoder().encode(user)
        let config = AuthNetworkConfig.register(data)

        let tokenResponse: TokenResponse = try await networkService.request(config: config, authorized: false)
        let token = tokenResponse.token.trimmingCharacters(in: .whitespacesAndNewlines)

        tokenStorage.saveToken(token)

        return tokenResponse
    }

    func login(credentials: AuthCredentials) async throws -> TokenResponse {
        let data = try JSONEncoder().encode(credentials)
        let config = AuthNetworkConfig.login(data)

        let tokenResponse: TokenResponse = try await networkService.request(config: config, authorized: false)
        let token = tokenResponse.token.trimmingCharacters(in: .whitespacesAndNewlines)

        tokenStorage.saveToken(token)

        return tokenResponse
    }

    func logout() async {
        guard let token = tokenStorage.retrieveToken() else {
            print("Ошибка: Токен отсутствует")
            return
        }

        let config = AuthNetworkConfig.logout

        do {
            let responseData = try await networkService.requestRaw(config: config, authorized: true)

            if let responseString = String(data: responseData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                print("Ответ сервера при выходе: \(responseString)")
            } else {
                print("Ошибка декодирования ответа")
            }
        } catch {
            print("Ошибка при выходе: \(error.localizedDescription)")
        }

        tokenStorage.deleteToken()
    }
}
