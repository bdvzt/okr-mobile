//
//  AuthNetworkConfig.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

enum AuthNetworkConfig: NetworkConfig {
    case register(Data)
    case login(Data)
    case logout
    
    var path: String {
        return "auth/"
    }
    
    var endPoint: String {
        switch self {
        case .register: return Constants.Endpoint.register
        case .login: return Constants.Endpoint.login
        case .logout: return Constants.Endpoint.logout
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .register(data),
            let .login(data):
            return .requestBody(data)
        case .logout:
            return .request
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
}

private extension AuthNetworkConfig {
    enum Constants {
        enum Endpoint {
            static let register = "register"
            static let login = "login"
            static let logout = "logout"
        }
    }
}
