//
//  RequestListDTO.swift
//  OKR
//
//  Created by Zayata Budaeva on 11.03.2025.
//

struct RequestListDTO: Codable {
    let id: Int
    let startedSkipping: String
    let finishedSkipping: String
    let status: String 
    let userId: Int
}
