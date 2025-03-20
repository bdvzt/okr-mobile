//
//  ProfileViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: ProfileViewModelProtocol

    // MARK: - Inits
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components

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

    private let requestsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let requestsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    // MARK: - Жизненный цикл

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loadProfile()
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
    }

    // MARK: - Настройка UI

    private func setupViews() {
        view.addSubview(profileInfoLabel)
        view.addSubview(requestsScrollView)
        view.addSubview(logoutButton)
        requestsScrollView.addSubview(requestsStackView)
    }

    private func setupConstraints() {
        profileInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }

        requestsScrollView.snp.makeConstraints { make in
            make.top.equalTo(profileInfoLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(logoutButton.snp.top).offset(-20)
        }

        requestsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    // MARK: - User info
    private func loadProfile() {
        Task {
            print("🔍 loadProfile() вызван") // ✅ Проверяем, вызывается ли метод
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
            print("✅ Данные пользователя получены: \(user.firstName) \(user.lastName), группа: \(user.group)")
            self.profileInfoLabel.text = "\(user.firstName) \(user.lastName)\nГруппа: \(user.group)"
            self.populateRequests(user.requestList)
        }
    }

    private func populateRequests(_ requests: [RequestDTO]) {
        requestsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // ✅ Формат сервера

        for request in requests {
            let requestView = RequestComponent()

            let startDate = dateFormatter.date(from: request.startedSkipping)
            let endDate = dateFormatter.date(from: request.finishedSkipping)

            if let startDate = startDate, let endDate = endDate {
                requestView.configure(startDate: startDate, endDate: endDate, status: .pending)
            } else {
                print("⚠️ Ошибка парсинга даты для заявки ID: \(request.id)")
            }
            requestsStackView.addArrangedSubview(requestView)
        }
    }

    private func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    // MARK: - Actions

    @objc private func logoutAction() {
        Task {
            await viewModel.logout()
            DispatchQueue.main.async {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first {
                    let authVC = AuthViewController(viewModel: AuthViewModel(
                        loginUseCase: LoginUseCase(authRepository: AuthRepositoryImpl())
                    ))

                    window.rootViewController = authVC
                    window.makeKeyAndVisible()
                }
            }
        }
    }
}
