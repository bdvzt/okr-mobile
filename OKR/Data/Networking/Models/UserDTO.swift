//
//  UserDTO.swift
//  OKR
//
//  Created by Zayata Budaeva on 11.03.2025.
//

struct UserDTO: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let studentGroup: String?
    let userRole: String
    let requestList: [RequestDTO]

    var group: String {
        if let studentGroup = studentGroup, let groupEnum = Group(rawValue: studentGroup) {
            return groupEnum.displayName
        } else {
            return "не указана"
        }
    }
}
