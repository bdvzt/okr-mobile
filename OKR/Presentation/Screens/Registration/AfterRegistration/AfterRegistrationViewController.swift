//
//  AfterRegistrationViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

class AfterRegistrationViewController: UIViewController {

    // MARK: - UI Elements

    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация прошла успешно.\nДля доступа к системе ожидайте подтверждения роли."
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
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
        view.addSubview(successLabel)
        view.addSubview(loginButton)
    }

    private func setupConstraints() {
        successLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(successLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }

    // MARK: - Actions

//    @objc private func didTapLoginButton() {
//        let authVC = AuthViewController()
//        authVC.modalPresentationStyle = .fullScreen
//        present(authVC, animated: true, completion: nil)
//    }
}

#Preview {
    AfterRegistrationViewController()
}

