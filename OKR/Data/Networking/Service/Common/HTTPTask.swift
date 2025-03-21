//
//  HTTPTask.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

typealias Parameters = [String: Any]

enum HTTPTask {
    case request
    case requestBody(Data)
    case requestUrlParameters(Parameters)
}
