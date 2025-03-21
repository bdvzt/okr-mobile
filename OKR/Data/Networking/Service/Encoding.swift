//
//  Encoding.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

struct URLParameterEncoder {
    func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }

        guard
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            parameters.isEmpty == false
        else { throw NetworkError.encodingError }

        urlComponents.queryItems = []

        parameters.forEach { name, value in
            if let arrayValue = value as? [Any] {
                arrayValue.forEach { value in
                    self.appendQueryItem(to: &urlComponents, for: name, value: value)
                }
            } else {
                self.appendQueryItem(to: &urlComponents, for: name, value: value)
            }
        }

        urlRequest.url = urlComponents.url
    }
}

private extension URLParameterEncoder {
    func appendQueryItem(to urlComponents: inout URLComponents, for name: String, value: Any) {
        let queryItem = URLQueryItem(
            name: name,
            value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        )

        urlComponents.queryItems?.append(queryItem)
    }
}
