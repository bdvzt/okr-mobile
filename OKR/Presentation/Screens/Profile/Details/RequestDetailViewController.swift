//
//  RequestDetailViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

import UIKit
import SnapKit
import UniformTypeIdentifiers

final class RequestDetailViewController: UIViewController, UIDocumentPickerDelegate {

    private let viewModel: RequestDetailViewModelProtocol
    private let requestId: Int

    private var datePickerView: UIView?
    private var selectedDatePicker: UIDatePicker?

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Детали заявки"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    private let requestView = RequestComponent()

    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить файл", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(selectFile), for: .touchUpInside)
        return button
    }()

    private let filesScrollView = UIScrollView()
    private let filesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()


    // MARK: - Init
    init(requestId: Int, viewModel: RequestDetailViewModelProtocol) {
        self.requestId = requestId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loadRequestDetails()
    }

    // MARK: - Setup UI
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(requestView)
        view.addSubview(uploadButton)
        view.addSubview(filesScrollView)
        filesScrollView.addSubview(filesStackView)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        requestView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }

        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(requestView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        filesScrollView.snp.makeConstraints { make in
            make.top.equalTo(uploadButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        filesStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    // MARK: - Load Data
    private func loadRequestDetails() {
        Task {
            do {
                let request = try await viewModel.fetchRequestDetails(requestId: requestId)
                DispatchQueue.main.async {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"

                    if let startDate = formatter.date(from: request.startedSkipping),
                       let endDate = formatter.date(from: request.finishedSkipping) {
                        self.requestView.configure(startDate: startDate, endDate: endDate, status: request.status, requestId: self.requestId) {
                            self.presentDatePicker()
                        }
                    }

                    self.displayFiles(request.files)
                }
            } catch {
                print("❌ Ошибка загрузки деталей заявки: \(error.localizedDescription)")
            }
        }
    }
    private func displayFiles(_ files: [FileInfoDTO]) {
        print("📂 Загружено файлов: \(files.count)")

        filesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for file in files {
            print("📄 Добавление файла: \(file.fileName)")

            let fileComponent = FileComponent()
            fileComponent.configure(fileId: file.id, fileName: file.fileName) { fileId in
                self.deleteFile(fileId: fileId)
            }
            filesStackView.addArrangedSubview(fileComponent)
        }

        filesScrollView.isHidden = files.isEmpty
    }


    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - File Upload
    @objc private func selectFile() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.image])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }

        do {
            let fileData = try Data(contentsOf: fileURL)
            let fileName = fileURL.lastPathComponent
            let mimeType = getMimeType(for: fileURL)

            print("📂 Выбран файл: \(fileName), MIME: \(mimeType)")

            Task {
                do {
                    try await viewModel.uploadFile(requestId: requestId, file: fileData, fileName: fileName, mimeType: mimeType)
                    DispatchQueue.main.async {
                        self.showAlert(title: "Успех", message: "Файл успешно загружен!")
                    }
                } catch {
                    print("❌ Ошибка загрузки файла: \(error.localizedDescription)")
                    self.showAlert(title: "Ошибка", message: "Не удалось загрузить файл.")
                }
            }
        } catch {
            print("❌ Ошибка чтения файла: \(error.localizedDescription)")
            showAlert(title: "Ошибка", message: "Не удалось прочитать файл.")
        }
    }

    private func getMimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension.lowercased()
        switch pathExtension {
        case "pdf": return "application/pdf"
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "txt": return "text/plain"
        default: return "application/octet-stream"
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func deleteFile(fileId: Int) {
        let alert = UIAlertController(
            title: "Удаление файла",
            message: "Вы уверены, что хотите удалить этот файл?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            Task {
                do {
                    try await self.viewModel.unpinFile(requestId: self.requestId, fileId: fileId)
                    DispatchQueue.main.async {
                        self.showAlert(title: "Успех", message: "Файл удален!")
                        self.loadRequestDetails()
                    }
                } catch {
                    print("❌ Ошибка удаления файла: \(error.localizedDescription)")
                    self.showAlert(title: "Ошибка", message: "Не удалось удалить файл.")
                }
            }
        }))

        present(alert, animated: true)
    }

    private func presentDatePicker() {
        let datePickerView = UIView()
        datePickerView.backgroundColor = .white
        datePickerView.layer.cornerRadius = 12

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()

        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Продлить", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.layer.cornerRadius = 8
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        confirmButton.addTarget(self, action: #selector(confirmExtension(_:)), for: .touchUpInside)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cancelButton.addTarget(self, action: #selector(dismissDatePicker), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [datePicker, confirmButton, cancelButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill

        datePickerView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }

        let modalVC = UIViewController()
        modalVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        modalVC.modalPresentationStyle = .overFullScreen

        modalVC.view.addSubview(datePickerView)

        datePickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }

        self.datePickerView = datePickerView
        self.selectedDatePicker = datePicker

        present(modalVC, animated: true)
    }

    @objc private func dismissDatePicker() {
        dismiss(animated: true)
    }

    @objc private func confirmExtension(_ sender: UIButton) {
        guard let selectedDate = selectedDatePicker?.date else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let formattedDate = dateFormatter.string(from: selectedDate)
        let extendRequestDTO = ExtendRequestDateDTO(extendSkipping: formattedDate)
        
        Task {
            do {
                try await viewModel.extendRequest(id: requestId, date: extendRequestDTO)
                DispatchQueue.main.async {
                    self.showAlert(title: "Успех", message: "Дата окончания продлена!")
                    self.loadRequestDetails()
                    self.dismiss(animated: true)
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Не удалось продлить заявку.")
                }
            }
        }
    }
}
