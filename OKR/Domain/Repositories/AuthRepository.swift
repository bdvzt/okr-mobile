//
//  AuthRepository.swift
//  OKR
//
//  Created by Zayata Budaeva on 12.03.2025.
//

import Foundation

protocol AuthRepository: AnyObject {
    func register(user: UserRegistration) async throws -> TokenResponse
    func login(credentials: AuthCredentials) async throws -> TokenResponse
    func logout() async
}
