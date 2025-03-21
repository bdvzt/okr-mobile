//
//  UserRepository.swift
//  OKR
//
//  Created by Zayata Budaeva on 20.03.2025.
//

import Foundation

protocol UserRepository: AnyObject {
    func getInfo() async throws -> UserDTO
}

