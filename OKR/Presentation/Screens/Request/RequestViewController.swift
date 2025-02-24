//
//  RequestViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

class RequestViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание заявки"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private let attachButton: UIButton = {
        let button = UIButton()
        button.setTitle("Прикрепить документ", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()

    private let sendRequestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()

    private var selectedDocument: URL?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        attachButton.addTarget(self, action: #selector(attachDocument), for: .touchUpInside)
        sendRequestButton.addTarget(self, action: #selector(submitRequest), for: .touchUpInside)
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(attachButton)
        view.addSubview(sendRequestButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
        }

        startDatePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        endDatePicker.snp.makeConstraints { make in
            make.top.equalTo(startDatePicker.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        attachButton.snp.makeConstraints { make in
            make.top.equalTo(endDatePicker.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        sendRequestButton.snp.makeConstraints { make in
            make.top.equalTo(attachButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }

    // MARK: - Actions

    @objc private func attachDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image], asCopy: true)
        documentPicker.delegate = self
        present(documentPicker, animated: true)
    }

    @objc private func submitRequest() {
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date

        if let document = selectedDocument {
            print("Дата начала: \(startDate), Дата окончания: \(endDate), Документ: \(document.lastPathComponent)")
        } else {
            print("Дата начала: \(startDate), Дата окончания: \(endDate), Документ не прикреплён")
        }
    }
}

// MARK: - UIDocumentPicker Delegate

extension RequestViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedDocument = urls.first
        print("Документ выбран: \(selectedDocument?.lastPathComponent ?? "Нет")")
    }
}

#Preview {
    RequestViewController()
}
