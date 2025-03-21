//
//  ExtendRequestUseCase.swift
//  OKR
//
//  Created by Zayata Budaeva on 20.03.2025.
//

protocol ExtendRequestUseCaseProtocol {
    func execute(id: Int, date: ExtendRequestDateDTO) async throws
}

final class ExtendRequestUseCase: ExtendRequestUseCaseProtocol {
    private let requestRepository: RequestRepository
    
    init(requestRepository: RequestRepository) {
        self.requestRepository = requestRepository
    }
    
    func execute(id: Int, date: ExtendRequestDateDTO) async throws {
        try await requestRepository.extendRequest(id: id, date: date)
    }
}
