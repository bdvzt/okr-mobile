//
//  ProfileViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModelProtocol

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let profileInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()

    private let requestsScrollView = UIScrollView()

    private let requestsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Обновить", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(refreshProfile), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loadProfile()
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
    }

    private func setupViews() {
        view.addSubview(profileInfoLabel)
        view.addSubview(requestsScrollView)
        view.addSubview(logoutButton)
        view.addSubview(refreshButton)
        requestsScrollView.addSubview(requestsStackView)
    }

    private func setupConstraints() {
        profileInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(profileInfoLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }

        requestsScrollView.snp.makeConstraints { make in
            make.top.equalTo(refreshButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(logoutButton.snp.top).offset(-20)
        }

        requestsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }

    private func loadProfile() {
        Task {
            do {
                let user = try await viewModel.getInfo()
                updateUI(with: user)
            } catch {
                showError(error.localizedDescription)
            }
        }
    }

    private func updateUI(with user: UserDTO) {
        DispatchQueue.main.async {
            self.profileInfoLabel.text = "\(user.firstName) \(user.lastName)\nГруппа: \(user.group)"
            self.populateRequests(user.requestList)
        }
    }

    private func populateRequests(_ requests: [RequestDTO]) {
        requestsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for request in requests {
            let requestView = RequestComponent()

            if let startDate = dateFormatter.date(from: request.startedSkipping),
               let endDate = dateFormatter.date(from: request.finishedSkipping) {
                requestView.configure(
                    startDate: startDate,
                    endDate: endDate,
                    status: request.status,
                    requestId: request.id
                ) { [weak self] in
                    let button = UIButton()
                    button.tag = request.id
                    self?.openRequestDetail(button)
                }
            }

            requestsStackView.addArrangedSubview(requestView)
        }
    }

    @objc private func openRequestDetail(_ sender: UIButton) {
        let requestId = sender.tag

        let requestRepository = RequestRepositoryImpl()

        let getRequestInfoUseCase = GetRequestInfoUseCase(requestRepository: requestRepository)
        let uploadFileUseCase = UploadFileUseCase(requestRepository: requestRepository)
        let unpinFileUseCase = UnpinFileUseCase(requestRepository: requestRepository)
        let extendRequestUseCase = ExtendRequestUseCase(requestRepository: requestRepository)

        let requestDetailVM = RequestDetailViewModel(
            getRequestInfoUseCase: getRequestInfoUseCase,
            uploadFileUseCase: uploadFileUseCase,
            unpinFileUseCase: unpinFileUseCase,
            extendRequestUseCase: extendRequestUseCase
        )

        let requestDetailVC = RequestDetailViewController(requestId: requestId, viewModel: requestDetailVM)
        requestDetailVC.modalPresentationStyle = .fullScreen
        present(requestDetailVC, animated: true)
    }

    private func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    @objc private func logoutAction() {
        Task {
            await viewModel.logout()
            DispatchQueue.main.async {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first {
                    let authVC = AuthViewController(viewModel: AuthViewModel(
                        loginUseCase: LoginUseCase(authRepository: AuthRepositoryImpl()),
                        getInfoUseCase: GetInfoUseCase(userRepository: UserRepositoryImpl()),
                        logoutUseCase: LogoutUseCase(authRepository: AuthRepositoryImpl())
                    ))

                    window.rootViewController = authVC
                    window.makeKeyAndVisible()
                }
            }
        }
    }

    @objc private func refreshProfile() {
        loadProfile()
    }
}
