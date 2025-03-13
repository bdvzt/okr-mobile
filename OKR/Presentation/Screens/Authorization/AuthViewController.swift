//
//  AuthViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {

    private let viewModel: AuthViewModelProtocol

    private let authLabel: UILabel = {
        let label = UILabel()
        label.text = "Авторизация"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    private let emailInput: InputField = InputField(placeholder: "Email")
    private let passwordInput: InputField = {
        let input = InputField(placeholder: "Пароль")
        input.setSecureTextEntry(true)
        return input
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()

    private let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()

    init(viewModel: AuthViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupActions()
        setupBindings()
    }

    private func setupViews() {
        view.addSubview(authLabel)
        view.addSubview(emailInput)
        view.addSubview(passwordInput)
        view.addSubview(loginButton)
        view.addSubview(registrationButton)
    }

    private func setupConstraints() {
        authLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        emailInput.snp.makeConstraints { make in
            make.top.equalTo(authLabel.snp.bottom).offset(150)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        passwordInput.snp.makeConstraints { make in
            make.top.equalTo(emailInput.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInput.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(didTapRegButton), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToTabBar()
            }
        }

        viewModel.onRegister = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToRegister()
            }
        }
    }

    @objc private func didTapLoginButton() {
        guard let email = emailInput.text, !email.isEmpty,
              let password = passwordInput.text, !password.isEmpty else {
            print("Введите email и пароль")
            return
        }

        Task {
            await viewModel.login(email: email, password: password)
        }
    }

    @objc private func didTapRegButton() {
        viewModel.onRegister?()
    }

    private func navigateToTabBar() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return
        }

        let tabBarVC = TabBarController()
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
    }

    private func navigateToRegister() {
        let registerVC = RegistrationViewController(viewModel: RegistrationViewModel(registerUseCase: RegisterUseCase(authRepository: AuthRepositoryImpl())))
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true, completion: nil)
    }
}

//
//#Preview {
//    AuthViewController()
//}
