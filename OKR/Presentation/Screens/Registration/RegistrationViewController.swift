//
//  RegistrationViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {

    // MARK: - UI Elements

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()

    private let registrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    private let emailInput: InputField = {
        let input = InputField(placeholder: "Email")
        return input
    }()

    private let surnameInput: InputField = {
        let input = InputField(placeholder: "Фамилия")
        return input
    }()

    private let nameInput: InputField = {
        let input = InputField(placeholder: "Имя")
        return input
    }()

    private let passwordInput: InputField = {
        let input = InputField(placeholder: "Пароль")
        input.setSecureTextEntry(true)
        return input
    }()

    private let confirmPasswordInput: InputField = {
        let input = InputField(placeholder: "Подтвердите пароль")
        input.setSecureTextEntry(true)
        return input
    }()

    private let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBlue
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
        view.addSubview(closeButton)
        view.addSubview(registrationLabel)
        view.addSubview(emailInput)
        view.addSubview(surnameInput)
        view.addSubview(nameInput)
        view.addSubview(passwordInput)
        view.addSubview(confirmPasswordInput)
        view.addSubview(registrationButton)
    }

    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(30)
        }

        registrationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        emailInput.snp.makeConstraints { make in
            make.top.equalTo(registrationLabel.snp.bottom).offset(150)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        surnameInput.snp.makeConstraints { make in
            make.top.equalTo(emailInput.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        nameInput.snp.makeConstraints { make in
            make.top.equalTo(surnameInput.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        passwordInput.snp.makeConstraints { make in
            make.top.equalTo(nameInput.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        confirmPasswordInput.snp.makeConstraints { make in
            make.top.equalTo(passwordInput.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordInput.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }

    // MARK: - Actions

    @objc private func didTapCloseButton() {
        let authVC = AuthViewController()
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true, completion: nil)
    }
}

#Preview {
    RegistrationViewController()
}
