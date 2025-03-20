//
//  UploadFileUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

import Foundation

protocol UploadFileUseCaseProtocol {
    func execute(requestId: Int, file: Data, fileName: String, mimeType: String) async throws
}

final class UploadFileUseCase: UploadFileUseCaseProtocol {
    private let requestRepository: RequestRepository

    init(requestRepository: RequestRepository) {
        self.requestRepository = requestRepository
    }

    func execute(requestId: Int, file: Data, fileName: String, mimeType: String) async throws {
        try await requestRepository.uploadFile(requestId: requestId, file: file, fileName: fileName, mimeType: mimeType)
    }
}
