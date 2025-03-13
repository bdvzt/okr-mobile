//
//  RequestRepositoryImpl.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

import Foundation

final class RequestRepositoryImpl: RequestRepository {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func sendRequest(dates: CreateRequestDTO) async throws -> RequestResultDTO {
        let requestData = try JSONEncoder().encode(dates)
        let config = RequestNetworkConfig.createRequest(requestData)

        let responseData = try await networkService.requestRaw(config: config, authorized: true)

        do {
            let decodedResponse = try JSONDecoder().decode(RequestResultDTO.self, from: responseData)
            print("Ответ от сервера (создание заявки): \(decodedResponse)")
            return decodedResponse
        } catch {
            let responseString = String(data: responseData, encoding: .utf8) ?? "Неизвестный ответ"
            print("Ошибка декодирования JSON: \(error.localizedDescription), ответ сервера: \(responseString)")
            throw NSError(domain: "RequestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка декодирования JSON: \(error.localizedDescription)"])
        }
    }

    func extendRequest(id: Int, date: ExtendRequestDateDTO) async throws {
        let requestData = try JSONEncoder().encode(date)
        let config = RequestNetworkConfig.extendDateRequest(id: id, data: requestData)
        _ = try await networkService.requestRaw(config: config, authorized: true)
    }

    func uploadFile(requestId: Int, file: Data) async throws {
        let config = RequestNetworkConfig.uploadFile(requestId: requestId, file: file)
        _ = try await networkService.requestRaw(config: config, authorized: true)
    }

    func unpinFile(requestId: Int, fileId: Int) async throws {
        let config = RequestNetworkConfig.unpinConfirmationFile(requestId: requestId, fileId: fileId)
        _ = try await networkService.requestRaw(config: config, authorized: true)
    }

    func getRequestList(userId: Int?) async throws -> [RequestListDTO] {
        let config = RequestNetworkConfig.downloadFile(fileId: userId ?? 0) // Указать правильный эндпоинт
        let responseData = try await networkService.requestRaw(config: config, authorized: true)
        return try JSONDecoder().decode([RequestListDTO].self, from: responseData)
    }
}
