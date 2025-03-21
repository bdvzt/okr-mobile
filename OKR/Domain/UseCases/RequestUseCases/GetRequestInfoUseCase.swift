//
//  GetRequestInfoUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

protocol GetRequestInfoUseCaseProtocol {
    func execute(requestId: Int) async throws -> RequestDetailsDTO
}

final class GetRequestInfoUseCase: GetRequestInfoUseCaseProtocol {
    private let requestRepository: RequestRepository

    init(requestRepository: RequestRepository) {
        self.requestRepository = requestRepository
    }

    func execute(requestId: Int) async throws -> RequestDetailsDTO {
        return try await requestRepository.getRequestInfo(requestId: requestId)
    }
}
