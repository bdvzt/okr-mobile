//
//  HTTPStatusCode.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201

    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404

    case internalServerError = 500
}

