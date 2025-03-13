//
//  ProfileViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

protocol ProfileViewModelProtocol: AnyObject {
    func logout() async
}

final class ProfileViewModel: ProfileViewModelProtocol {
    private let logoutUseCase: LogoutUseCaseProtocol

    init(logoutUseCase: LogoutUseCaseProtocol) {
        self.logoutUseCase = logoutUseCase
    }

    func logout() async {
        do {
            try await logoutUseCase.execute()
            print("Выход выполнен успешно")
        } catch {
            print("Ошибка выхода: \(error.localizedDescription)")
        }
    }
}
