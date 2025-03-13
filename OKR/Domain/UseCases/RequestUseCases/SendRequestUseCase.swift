//
//  SendRequestUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

protocol SendRequestUseCaseProtocol {
    func execute(dates: CreateRequestDTO) async throws -> RequestResultDTO
}

final class SendRequestUseCase: SendRequestUseCaseProtocol {
    private let requestRepository: RequestRepository

    init(requestRepository: RequestRepository) {
        self.requestRepository = requestRepository
    }

    func execute(dates: CreateRequestDTO) async throws -> RequestResultDTO {
        return try await requestRepository.sendRequest(dates: dates)
    }
}
