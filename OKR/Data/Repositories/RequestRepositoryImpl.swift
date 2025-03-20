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

    func sendRequest(dates: CreateRequestDTO) async throws -> RequestDTO {
        let requestData = try JSONEncoder().encode(dates)
        let config = RequestNetworkConfig.createRequest(requestData)

        let responseData = try await networkService.requestRaw(config: config, authorized: true)

        do {
            let decodedResponse = try JSONDecoder().decode(RequestDTO.self, from: responseData)
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

        let responseData = try await networkService.requestRaw(config: config, authorized: true)

        if let responseString = String(data: responseData, encoding: .utf8) {
            print("Ответ от сервера (продление заявки): \(responseString)")
        } else {
            print("Ошибка: Сервер вернул некорректный ответ при продлении заявки")
        }
    }

    func getRequestInfo(requestId: Int) async throws -> RequestDetailsDTO {
        let config = RequestNetworkConfig.getRequestInfo(requestId: requestId)
        print("🔗 URL: \(config.path + config.endPoint)")
        print("🆔 ID заявки: \(requestId)")
        print("📌 HTTP Метод: \(config.method.rawValue)")
        let responseData = try await networkService.requestRaw(config: config, authorized: true)
        do {
            let decodedResponse = try JSONDecoder().decode(RequestDetailsDTO.self, from: responseData)
            print("✅ Получена информация о заявке: \(decodedResponse)")
            return decodedResponse
        } catch {
            let responseString = String(data: responseData, encoding: .utf8) ?? "Неизвестный ответ"
            print("❌ Ошибка декодирования JSON: \(error.localizedDescription), ответ сервера: \(responseString)")
            throw NSError(domain: "RequestError", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Ошибка декодирования JSON: \(error.localizedDescription)"
            ])
        }
    }

    func uploadFile(requestId: Int, file: Data, fileName: String, mimeType: String) async throws {
        let uploadURL = URL(string: "http://95.182.120.75:8081/request/upload/\(requestId)")!

        print("📡 Загрузка файла \(fileName) в заявку ID: \(requestId) с MIME-типом \(mimeType)")

        try await networkService.uploadFileRequest(
            url: uploadURL,
            fileData: file,
            fileName: fileName,
            mimeType: mimeType,
            authorized: true
        )
    }

    func unpinFile(requestId: Int, fileId: Int) async throws {
        let config = RequestNetworkConfig.unpinConfirmationFile(requestId: requestId, fileId: fileId)
        _ = try await networkService.requestRaw(config: config, authorized: true)
    }
}
