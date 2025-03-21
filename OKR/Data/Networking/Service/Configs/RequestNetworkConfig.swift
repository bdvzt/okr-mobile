//
//  RequestNetworkConfig.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

enum RequestNetworkConfig: NetworkConfig {
    case createRequest(Data)
    case uploadFile(requestId: Int, file: Data)
    case extendDateRequest(id: Int, data: Data)
    case unpinConfirmationFile(requestId: Int, fileId: Int)
    case getRequestInfo(requestId: Int)

    var path: String {
        return Constants.Path.request
    }

    var endPoint: String {
        switch self {
        case .createRequest:
            return Constants.Endpoint.createRequest
        case let .uploadFile(requestId, _):
            return "\(Constants.Endpoint.uploadFile)\(requestId)"
        case let .extendDateRequest(id, _):
            return "\(Constants.Endpoint.extendDateRequest)\(id)"
        case let .unpinConfirmationFile(requestId, fileId):
            return "\(Constants.Endpoint.unpinConfirmationFile)\(requestId)/\(fileId)"
        case let .getRequestInfo(requestId):
            return "\(Constants.Endpoint.getRequestInfo)\(requestId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createRequest, .uploadFile:
            return .post
        case .extendDateRequest:
            return .patch
        case .getRequestInfo:
            return .get
        case .unpinConfirmationFile:
            return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case let .createRequest(data),
            let .extendDateRequest(_, data):
            return .requestBody(data)
        case let .uploadFile(_, file):
            return .requestBody(file)
        case .unpinConfirmationFile, .getRequestInfo:
            return .request
        }
    }
}

private extension RequestNetworkConfig {
    enum Constants {
        enum Path {
            static let request = "request"
        }

        enum Endpoint {
            static let createRequest = ""
            static let uploadFile = "/upload/"
            static let extendDateRequest = "/"
            static let unpinConfirmationFile = "/file/unpin/"
            static let getRequestInfo = "/info/"
        }
    }
}
