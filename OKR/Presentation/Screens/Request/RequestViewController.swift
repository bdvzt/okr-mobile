//
//  RequestViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 25.02.2025.
//

import UIKit
import SnapKit

final class RequestViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Свойства
    private let viewModel: RequestViewModelProtocol

    // MARK: - Инициализация
    init(viewModel: RequestViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Элементы

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
        button.addTarget(self, action: #selector(attachDocument), for: .touchUpInside)
        return button
    }()

    private let sendRequestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(submitRequest), for: .touchUpInside)
        return button
    }()

    private var selectedDocument: URL?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupBindings()
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

    private func setupBindings() {
        viewModel.onRequestSuccess = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Успех", message: message)
            }
        }

        viewModel.onRequestFailure = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(title: "Ошибка", message: errorMessage)
            }
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

        let dateFormatter = ISO8601DateFormatter()
        let startString = dateFormatter.string(from: startDate)
        let endString = dateFormatter.string(from: endDate)

        let request = CreateRequestDTO(startedSkipping: startString, finishedSkipping: endString)

        Task {
            await viewModel.sendRequest(dates: request)
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIDocumentPicker Delegate

extension RequestViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedDocument = urls.first
        print("Документ выбран: \(selectedDocument?.lastPathComponent ?? "Нет")")
    }
}
