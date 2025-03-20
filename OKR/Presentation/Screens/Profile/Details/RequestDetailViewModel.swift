//
//  RequestDetailViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

import Foundation

protocol RequestDetailViewModelProtocol {
    func fetchRequestDetails(requestId: Int) async throws -> RequestDetailsDTO
}

final class RequestDetailViewModel: RequestDetailViewModelProtocol {
    private let getRequestInfoUseCase: GetRequestInfoUseCaseProtocol
    
    init(getRequestInfoUseCase: GetRequestInfoUseCaseProtocol) {
        self.getRequestInfoUseCase = getRequestInfoUseCase
    }
    
    func fetchRequestDetails(requestId: Int) async throws -> RequestDetailsDTO {
        return try await getRequestInfoUseCase.execute(requestId: requestId)
    }
}

