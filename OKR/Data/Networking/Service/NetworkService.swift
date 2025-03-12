//
//  NetworkService.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func request(config: NetworkConfig, authorized: Bool) async throws
    func request<T: Decodable>(config: NetworkConfig, authorized: Bool) async throws -> T
}

final class NetworkService {
    private enum NetworkConstants
    {
        static let authorizationHeader = "Authorization"
        static let jsonContentType = "application/json"
        static let contentTypeHeader = "Content-Type"
    }

    private let decoder = JSONDecoder()
    private let logger: LoggerProtocol
    private let apiConfiguration: ApiConfiguration
    private let tokenStorage: TokenStorageProtocol

    init(
        apiConfiguration: ApiConfiguration,
        tokenStorage: TokenStorageProtocol,
        logger: LoggerProtocol
    ) {
        self.apiConfiguration = apiConfiguration
        self.tokenStorage = tokenStorage
        self.logger = logger
        self.decoder.dateDecodingStrategy = .iso8601
    }
}

// MARK: NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol
{
    func request(config: NetworkConfig, authorized: Bool) async throws {
        do {
            let requestURL = try self.createRequestURL(config: config)
            let body: Data? = self.bodyData(config: config)
            self.logger.logRequest(
                url: requestURL,
                method: config.method.rawValue,
                body: body,
                level: .verbose
            )
            try await self.makeRequest(config: config, authorized: authorized)
            self.logger.log("Request completed successfully", level: .verbose, additionalInfo: [
                "URL": requestURL,
                "Method": config.method.rawValue
            ])
        } catch {
            self.logger.logError(error, level: .error)
            throw error
        }
    }

    func request<T: Decodable>(config: NetworkConfig, authorized: Bool) async throws -> T {
        do {
            let requestURL = try self.createRequestURL(config: config)
            let body: Data? = self.bodyData(config: config)
            self.logger.logRequest(
                url: requestURL,
                method: config.method.rawValue,
                body: body,
                level: .verbose
            )
            let data = try await self.makeRequest(config: config, authorized: authorized)
            self.logger.logResponse(
                url: requestURL,
                statusCode: 200,
                body: body,
                level: .verbose
            )
            return try self.decode(data)
        } catch {
            self.logger.logError(error, level: .error)
            throw error
        }
    }
}

// MARK: - Private methods

private extension NetworkService
{
    func decode<T: Decodable>(_ data: Data) throws -> T {
        guard let value = try? self.decoder.decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }

        return value
    }

    func handleResponse(_ response: URLResponse) throws {
        guard
            let httpResponse = response as? HTTPURLResponse,
            (200 ... 299).contains(httpResponse.statusCode)
        else {
            throw NetworkError.invalidResponse
        }
    }

    @discardableResult
    func makeRequest(config: NetworkConfig, authorized: Bool) async throws -> Data {
        let token: String? = try await self.determineAccessToken(authorized: authorized)
        let urlRequest = try self.buildRequest(config: config, token: token)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)

        do {
            try self.handleResponse(urlResponse)
        } catch {
            let errorMessage: ErrorMessage = try self.decode(data)
            guard let serverError = ServerError.byCode(errorMessage.id) else {
                throw error
            }

            if case .authorizationRequired = serverError {
                try self.tokenStorage.deleteToken()
            }

            throw serverError
        }
        return data
    }

    func buildRequest(config: NetworkConfig, token: String?) throws -> URLRequest {
        let urlString = self.apiConfiguration.gatewayEndpoint + config.path + config.endPoint
        guard let url = URL(string: urlString) else { throw NetworkError.missingURL }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)

        switch config.task {
        case .request: break

        case let .requestBody(data):
            guard config.method == .post || config.method == .put else {
                throw NetworkError.methodNotAllowed
            }

            urlRequest.httpBody = data

        case let .requestUrlParameters(parameters):
            try URLParameterEncoder().encode(urlRequest: &urlRequest, parameters: parameters)
        }

        urlRequest.httpMethod = config.method.rawValue
        urlRequest.setValue(NetworkConstants.jsonContentType, forHTTPHeaderField: NetworkConstants.contentTypeHeader)

        if let token {
            urlRequest.addValue(token, forHTTPHeaderField: NetworkConstants.authorizationHeader)
        }

        return urlRequest
    }

    func determineAccessToken(authorized: Bool) async throws -> String? {
        guard authorized else { return nil }

        var token: TokenResponse?
        do {
            token = try self.tokenStorage.retrieveToken()
            return token?.accessToken
        } catch KeychainStorage.KeychainError.tokenExpired {
            guard let token else { return nil }

            let updatedToken = try await self.requestUpdatedToken(
                refreshToken: token.refreshToken,
                authorized: authorized
            )
            try self.tokenStorage.saveToken(updatedToken)

            return updatedToken.accessToken
        } catch {
            throw error
        }
    }

    func requestUpdatedToken(refreshToken: String, authorized: Bool) async throws -> TokenResponse {
        let data = try JSONEncoder().encode(refreshToken)
        let config = AuthNetworkConfig.refresh(data)

        let updatedTokenData = try await self.makeRequest(config: config, authorized: authorized)
        let updatedToken = try self.decoder.decode(TokenResponse.self, from: updatedTokenData)

        return updatedToken
    }
}

private extension NetworkService
{
    func bodyData(config: NetworkConfig) -> Data? {
        switch config.task {
        case .requestBody(let data):
            return data
        default:
            return nil
        }
    }

    func createRequestURL(config: NetworkConfig) throws -> URL {
        let urlString = self.apiConfiguration.gatewayEndpoint + config.path + config.endPoint
        guard let requestURL = URL(string: urlString) else {
            throw NetworkError.missingURL
        }
        return requestURL
    }
}
