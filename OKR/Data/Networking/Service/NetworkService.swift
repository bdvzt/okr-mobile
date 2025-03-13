//
//  NetworkService.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(config: NetworkConfig, authorized: Bool) async throws -> T
    func requestRaw(config: NetworkConfig, authorized: Bool) async throws -> Data
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = URL(string: "http://95.182.120.75:8081/")!
    private let tokenStorage = TokenStorage()

    func request<T: Decodable>(config: NetworkConfig, authorized: Bool) async throws -> T {
        let data = try await requestRaw(config: config, authorized: authorized)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func requestRaw(config: NetworkConfig, authorized: Bool) async throws -> Data {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(config.path + config.endPoint))
        urlRequest.httpMethod = config.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if authorized, let token = tokenStorage.retrieveToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if case let .requestBody(data) = config.task {
            urlRequest.httpBody = data
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("HTTP Status Code: \(httpResponse.statusCode)")

        if !(200...299).contains(httpResponse.statusCode) {
            throw NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Ошибка \(httpResponse.statusCode)"])
        }

        return data
    }
}
