//
//  AuthRepository.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

protocol AuthRepository: AnyObject {
    func register(user: UserRegistration) async throws
    func login(credentials: AuthCredentials) async throws
    func logout() async throws
}
