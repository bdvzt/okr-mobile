//
//  RequestDetailViewController.swift
//  OKR
//
//  Created by Zayata Budaeva on 21.03.2025.
//

import UIKit
import SnapKit

final class RequestDetailViewController: UIViewController {

    private let viewModel: RequestDetailViewModelProtocol
    private let requestId: Int

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
                        self.requestView.configure(startDate: startDate, endDate: endDate, status: request.status)
                    }
                }
            } catch {
                print("❌ Ошибка загрузки деталей заявки: \(error.localizedDescription)")
            }
        }
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
