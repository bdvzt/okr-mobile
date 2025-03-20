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
    func getRequestInfo(requestId: Int) async throws -> RequestDetailsDTO
    func uploadFile(requestId: Int, file: Data, fileName: String, mimeType: String) async throws
    func unpinFile(requestId: Int, fileId: Int) async throws
}
