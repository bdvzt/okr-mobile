//
//  RequestRepository.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

protocol RequestRepository: AnyObject {
    func sendRequest(dates: CreateRequestDTO) async throws -> RequestDTO
    func extendRequest(id: Int, date: ExtendRequestDateDTO) async throws
    func uploadFile(requestId: Int, file: Data) async throws
    func unpinFile(requestId: Int, fileId: Int) async throws
    func getRequestList(userId: Int?) async throws -> [RequestListDTO]
}
