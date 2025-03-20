//
//  RequestResultDTO.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

struct RequestDTO: Decodable {
    let id: Int
    let startedSkipping: String
    let finishedSkipping: String
    let status: RequestStatus

    enum CodingKeys: String, CodingKey {
        case id, startedSkipping, finishedSkipping, status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        startedSkipping = try container.decode(String.self, forKey: .startedSkipping)
        finishedSkipping = try container.decode(String.self, forKey: .finishedSkipping)

        let statusString = try container.decode(String.self, forKey: .status)
        status = RequestStatus(rawValue: statusString) ?? .pending
    }
}
