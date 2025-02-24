//
//  InputField.swift
//  OKR
//
//  Created by Zayata Budaeva on 24.02.2025.
//

import UIKit
import SnapKit

final class InputField: UIInputView {

    // MARK: - Private properties

    private let textField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }()

    // MARK: - Inits

    init(placeholder: String) {
        super.init(frame: .zero, inputViewStyle: .default)
        setup(placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(placeholder: String) {
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 16
        addSubview(textField)

        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }

    // MARK: - Methods

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    func setSecureTextEntry(_ isSecure: Bool) {
        textField.isSecureTextEntry = isSecure
    }

}

