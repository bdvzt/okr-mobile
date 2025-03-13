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

    var isAuthorized: Bool {
        tokenStorage.retrieveToken() != nil
    }

    func register(user: UserRegistration) async throws {
        let data = try JSONEncoder().encode(user)
        let config = AuthNetworkConfig.register(data)

        let responseData: Data = try await networkService.request(config: config, authorized: false)

        guard let token = String(data: responseData, encoding: .utf8) else {
            throw NSError(domain: "RegistrationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid token format"])
        }

        print("Полученный токен при регистрации: \(token)")

        tokenStorage.saveToken(token)
    }

    func login(credentials: AuthCredentials) async throws {
        let data = try JSONEncoder().encode(credentials)
        let config = AuthNetworkConfig.login(data)

        let responseData = try await networkService.requestRaw(config: config, authorized: false)

        guard let token = String(data: responseData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid token format"])
        }

        print("Полученный токен: \(token)")

        tokenStorage.saveToken(token)
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
