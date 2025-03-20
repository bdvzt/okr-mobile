//
//  RequestComponent.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

final class RequestComponent: UIView {
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    private let statusLabel = UILabel()
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        styleView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [startDateLabel, endDateLabel, statusLabel, editButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .equalSpacing
        addSubview(stack)

        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    private func styleView() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        backgroundColor = .white
    }

    func configure(startDate: Date, endDate: Date, status: RequestStatus) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        startDateLabel.text = formatter.string(from: startDate)
        endDateLabel.text = formatter.string(from: endDate)

        statusLabel.text = {
            switch status {
            case .pending:
                return "На проверке"
            case .accepted:
                return "Подтверждено"
            case .rejected:
                return "Отклонено"
            }
        }()
        statusLabel.textColor = {
            switch status {
            case .pending:
                return .systemBlue
            case .accepted:
                return .systemGreen
            case .rejected:
                return .systemRed
            }
        }()
    }

    func setRequestId(_ id: Int) {
        editButton.tag = id
    }

    func setEditAction(target: Any?, action: Selector) {
        editButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

