//
//  UnpinFileUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

protocol UnpinFileUseCaseProtocol {
    func execute(requestId: Int, fileId: Int) async throws
}

final class UnpinFileUseCase: UnpinFileUseCaseProtocol {
    private let requestRepository: RequestRepository

    init(requestRepository: RequestRepository) {
        self.requestRepository = requestRepository
    }

    func execute(requestId: Int, fileId: Int) async throws {
        try await requestRepository.unpinFile(requestId: requestId, fileId: fileId)
    }
}
