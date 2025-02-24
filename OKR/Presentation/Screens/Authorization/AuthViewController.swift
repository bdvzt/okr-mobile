//
//  AuthViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {

    // MARK: - Private properties

    private let authLabel: UILabel = {
        let label = UILabel()
        label.text = "Авторизация"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    private let emailInput: InputField = {
        let input = InputField(placeholder: "Email")
        return input
    }()

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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup

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
}

#Preview {
    AuthViewController()
}
