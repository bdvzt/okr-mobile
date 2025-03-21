//
//  RequestComponent.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

final class RequestComponent: UIView {

    private let startTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Начало"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        return label
    }()

    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let endTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Конец"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        return label
    }()

    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    private var requestId: Int?
    private var editAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        styleView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let startStack = UIStackView(arrangedSubviews: [startTitleLabel, startDateLabel])
        startStack.axis = .vertical
        startStack.spacing = 2

        let endStack = UIStackView(arrangedSubviews: [endTitleLabel, endDateLabel])
        endStack.axis = .vertical
        endStack.spacing = 2

        let mainStack = UIStackView(arrangedSubviews: [startStack, endStack, statusLabel, editButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.distribution = .fill

        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }

        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    private func styleView() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        backgroundColor = .white
    }

    func configure(startDate: Date, endDate: Date, status: RequestStatus, requestId: Int, editAction: @escaping () -> Void) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        startDateLabel.text = formatter.string(from: startDate)
        endDateLabel.text = formatter.string(from: endDate)
        self.requestId = requestId
        self.editAction = editAction

        statusLabel.text = {
            switch status {
            case .pending: return "На проверке"
            case .accepted: return "Подтверждено"
            case .rejected: return "Отклонено"
            }
        }()

        statusLabel.textColor = {
            switch status {
            case .pending: return .systemBlue
            case .accepted: return .systemGreen
            case .rejected: return .systemRed
            }
        }()
    }

    @objc private func editButtonTapped() {
        editAction?()
    }
}
