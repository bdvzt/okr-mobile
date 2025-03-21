//
//  UserNetworkConfig.swift
//  OKR
//
//  Created by Zayata Budaeva on 20.03.2025.
//

import Foundation

enum UserNetworkConfig: NetworkConfig {
    case userInfo

    var path: String {
        return "users/"
    }

    var endPoint: String {
        switch self {
        case .userInfo: return Constants.Endpoint.info
        }
    }

    var task: HTTPTask {
        switch self {
        case .userInfo:
            return .request
        }
    }

    var method: HTTPMethod {
        return .get
    }
}

private extension UserNetworkConfig {
    enum Constants {
        enum Endpoint {
            static let info = "me"
        }
    }
}
