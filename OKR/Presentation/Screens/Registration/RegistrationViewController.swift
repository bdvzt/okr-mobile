//
//  RegistrationViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import UIKit
import SnapKit

final class RegistrationViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: RegistrationViewModelProtocol

    // MARK: - Init
    init(viewModel: RegistrationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private let emailInput = InputField(placeholder: "Email")
    private let surnameInput = InputField(placeholder: "Фамилия")
    private let nameInput = InputField(placeholder: "Имя")
    private let passwordInput = InputField(placeholder: "Пароль")
    private let confirmPasswordInput = InputField(placeholder: "Подтвердите пароль")

    private let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
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
        passwordInput.setSecureTextEntry(true)
        confirmPasswordInput.setSecureTextEntry(true)

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
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapRegisterButton() {
        guard let email = emailInput.text,
              let surname = surnameInput.text,
              let name = nameInput.text,
              let password = passwordInput.text,
              let confirmPassword = confirmPasswordInput.text else {
            print("Заполните все поля")
            return
        }

        guard password == confirmPassword else {
            print("Пароли не совпадают")
            return
        }

        Task {
            await viewModel.register(firstName: name, lastName: surname, email: email, password: password)
        }
    }
}
//
//#Preview {
//    RegistrationViewController()
//}
