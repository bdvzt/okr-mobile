//
//  Group.swift
//  OKR
//
//  Created by Zayata Budaeva on 20.03.2025.
//

enum Group: String, CaseIterable, Encodable {
    case first = "GROUP_972301"
    case second = "GROUP_972302"
    case third = "GROUP_972303"

    var displayName: String {
        switch self {
        case .first: return "972301"
        case .second: return "972302"
        case .third: return "972303"
        }
    }
}
