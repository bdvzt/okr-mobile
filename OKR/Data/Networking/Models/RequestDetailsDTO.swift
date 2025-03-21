//
//  RequestDetailsDTO.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

import Foundation

struct RequestDetailsDTO: Decodable {
    let id: Int
    let startedSkipping: String
    let finishedSkipping: String
    let status: RequestStatus
    let files: [FileInfoDTO]
    let user: RequestUserDTO

    enum CodingKeys: String, CodingKey {
        case id, startedSkipping, finishedSkipping, status, files, user
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        startedSkipping = try container.decode(String.self, forKey: .startedSkipping)
        finishedSkipping = try container.decode(String.self, forKey: .finishedSkipping)
        files = try container.decode([FileInfoDTO].self, forKey: .files)
        user = try container.decode(RequestUserDTO.self, forKey: .user)

        let statusString = try container.decode(String.self, forKey: .status)
        status = RequestStatus(rawValue: statusString) ?? .pending
    }
}

struct RequestUserDTO: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let studentGroup: String?
    let userRole: String

    var group: String {
        if let studentGroup = studentGroup, let groupEnum = Group(rawValue: studentGroup) {
            return groupEnum.displayName
        } else {
            return "Не указана"
        }
    }
}
