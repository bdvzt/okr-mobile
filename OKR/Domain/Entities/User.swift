//
//  User.swift
//  OKR
//
//  Created by Zayata Budaeva on 11.03.2025.
//

struct User {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let studentGroup: Group
    let userRole: UserRole
    let requestList: [Request]
}
