//
//  RequestViewModel.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

protocol RequestViewModelProtocol: AnyObject {
    func sendRequest(dates: CreateRequestDTO) async
    var onRequestSuccess: ((String) -> Void)? { get set }
    var onRequestFailure: ((String) -> Void)? { get set }
}

final class RequestViewModel: RequestViewModelProtocol {
    private let sendRequestUseCase: SendRequestUseCaseProtocol

    var onRequestSuccess: ((String) -> Void)?
    var onRequestFailure: ((String) -> Void)?

    init(sendRequestUseCase: SendRequestUseCaseProtocol) {
        self.sendRequestUseCase = sendRequestUseCase
    }

    func sendRequest(dates: CreateRequestDTO) async {
        do {
            _ = try await sendRequestUseCase.execute(dates: dates)

            await MainActor.run { [weak self] in
                self?.onRequestSuccess?("Заявка успешно отправлена!")
            }
        } catch {
            print("Ошибка: \(error.localizedDescription)")

            await MainActor.run { [weak self] in
                self?.onRequestFailure?("Ошибка при отправке заявки: \(error.localizedDescription)")
            }
        }
    }
}
