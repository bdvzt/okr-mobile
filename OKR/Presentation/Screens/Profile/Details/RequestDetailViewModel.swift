//
//  RequestDetailViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

import Foundation

protocol RequestDetailViewModelProtocol {
    func fetchRequestDetails(requestId: Int) async throws -> RequestDetailsDTO
    func uploadFile(requestId: Int, file: Data, fileName: String, mimeType: String) async throws
    func unpinFile(requestId: Int, fileId: Int) async throws
}

final class RequestDetailViewModel: RequestDetailViewModelProtocol {
    private let getRequestInfoUseCase: GetRequestInfoUseCaseProtocol
    private let uploadFileUseCase: UploadFileUseCaseProtocol
    private let unpinFileUseCase: UnpinFileUseCaseProtocol

    init(
        getRequestInfoUseCase: GetRequestInfoUseCaseProtocol,
        uploadFileUseCase: UploadFileUseCaseProtocol,
        unpinFileUseCase: UnpinFileUseCaseProtocol
    ) {
        self.getRequestInfoUseCase = getRequestInfoUseCase
        self.uploadFileUseCase = uploadFileUseCase
        self.unpinFileUseCase = unpinFileUseCase
    }

    func fetchRequestDetails(requestId: Int) async throws -> RequestDetailsDTO {
        return try await getRequestInfoUseCase.execute(requestId: requestId)
    }

    func uploadFile(requestId: Int, file: Data, fileName: String, mimeType: String) async throws {
        try await uploadFileUseCase.execute(requestId: requestId, file: file, fileName: fileName, mimeType: mimeType)
    }

    func unpinFile(requestId: Int, fileId: Int) async throws {
        try await unpinFileUseCase.execute(requestId: requestId, fileId: fileId)
    }
}
