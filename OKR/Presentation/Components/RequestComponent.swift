//
//  RequestComponent.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

final class RequestComponent: UIView {

    // MARK: - UI Elements

    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "..."
        return label
    }()

    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "..."
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.text = "На проверке"
        return label
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    private let requestStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        styleView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupViews() {
        requestStack.addArrangedSubview(startDateLabel)
        requestStack.addArrangedSubview(endDateLabel)
        requestStack.addArrangedSubview(statusLabel)
        requestStack.addArrangedSubview(editButton)

        addSubview(requestStack)
    }

    private func setupConstraints() {
        requestStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    private func styleView() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        backgroundColor = .white
    }

    // MARK: - Public API

    func configure(startDate: Date, endDate: Date, status: RequestStatus) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        startDateLabel.text = "\(formatter.string(from: startDate))"
        endDateLabel.text = "\(formatter.string(from: endDate))"

        switch status {
        case .pending:
            statusLabel.text = "На проверке"
            statusLabel.textColor = .systemBlue
        case .approved:
            statusLabel.text = "Подтверждено"
            statusLabel.textColor = .systemGreen
        case .declined:
            statusLabel.text = "Отклонено"
            statusLabel.textColor = .systemRed
        }
    }

    // MARK: - Actions (пока без реализации)
    func setEditAction(target: Any?, action: Selector) {
        editButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
