//
//  Request.swift
//  OKR
//
//  Created by Zayata Budaeva on 11.03.2025.
//

import Foundation

struct Request {
    let id: Int
    let startedSkipping: Date
    let finishedSkipping: Date
    let status: RequestStatus?
    let user: User?
    let proofs: [FileEntity]?
}
