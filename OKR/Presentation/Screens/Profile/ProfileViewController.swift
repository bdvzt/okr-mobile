//
//  ProfileViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    // MARK: - Свойства
    private let viewModel: ProfileViewModelProtocol

    // MARK: - Инициализация
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Элементы

    private let profileInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Иван\nИванов"
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
        setupDummyRequests()
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

    private func setupDummyRequests() {
        let now = Date()
        for _ in 0..<3 {
            let requestView = RequestComponent()
            let startDate = now
            let endDate = Calendar.current.date(byAdding: .day, value: 5, to: now)!
            requestView.configure(startDate: startDate, endDate: endDate, status: .pending)
            requestsStackView.addArrangedSubview(requestView)
        }
    }

    // MARK: - Действия

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

