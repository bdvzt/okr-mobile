//
//  FileComponent.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

import UIKit
import SnapKit

final class FileComponent: UIView {
    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "trash")
        button.setImage(image, for: .normal)
        button.tintColor = .systemRed
        return button
    }()

    private let fileStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private var fileId: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        styleView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        fileStack.addArrangedSubview(fileNameLabel)
        fileStack.addArrangedSubview(deleteButton)
        addSubview(fileStack)
    }

    private func setupConstraints() {
        fileStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    private func styleView() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        backgroundColor = .white
    }
    
    func configure(fileId: Int, fileName: String, deleteAction: @escaping (Int) -> Void) {
        self.fileId = fileId
        fileNameLabel.text = fileName
        deleteButton.addAction(UIAction { [weak self] _ in
            guard let self = self, let id = self.fileId else { return }
            deleteAction(id)
        }, for: .touchUpInside)
    }
}
