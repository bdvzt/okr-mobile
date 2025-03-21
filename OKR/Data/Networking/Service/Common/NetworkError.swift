//
//  NetworkError.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

enum NetworkError: Error {
    case noConnect
    case missingURL
    case invalidData
    case unauthorized
    case requestFailed
    case decodingError
    case encodingError
    case invalidResponse
    case methodNotAllowed
}
