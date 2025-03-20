//
//  ProfileViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 13.03.2025.
//

protocol ProfileViewModelProtocol: AnyObject {
    func logout() async
    func getInfo() async throws -> UserDTO
}

final class ProfileViewModel: ProfileViewModelProtocol {
    private let logoutUseCase: LogoutUseCaseProtocol
    private let getInfoUseCase: GetInfoUseCaseProtocol

    init(logoutUseCase: LogoutUseCaseProtocol, getInfoUseCase: GetInfoUseCaseProtocol) {
        self.logoutUseCase = logoutUseCase
        self.getInfoUseCase = getInfoUseCase
    }

    func logout() async {
        do {
            try await logoutUseCase.execute()
            print("Выход выполнен успешно")
        } catch {
            print("Ошибка выхода: \(error.localizedDescription)")
        }
    }

    func getInfo() async throws -> UserDTO {
        return try await getInfoUseCase.execute()
    }
}
