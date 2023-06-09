//
//  NetworkErrorViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-04-19.
//

import UIKit

protocol NetworkErrorViewControllerDelegate: AnyObject {
    func retryFetchingCategories()
}

class NetworkErrorViewController: UIViewController {

    private let stackView = UIStackView()
    private let errorLabel = UILabel()
    private let tryAgainButton = UIButton(type: .system)

    weak var delegate: NetworkErrorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

//MARK: - UI Configuration
extension NetworkErrorViewController {
    private func configureView() {
        view.backgroundColor = .white

        view.addSubview(stackView)
        stackView.addArrangedSubviews(errorLabel, tryAgainButton)

        configureStackView()
        configureErrorLabel()
        configureTryAgainButton()
    }

    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: K.Spacing.marginMultiplier),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: K.Spacing.marginMultiplier)
        ])
    }

    private func configureErrorLabel() {
        errorLabel.text = "Something went wrong. Please check your internet connection and try again."
        errorLabel.numberOfLines = -1
        errorLabel.textAlignment = .center
    }

    private func configureTryAgainButton() {
        tryAgainButton.setTitle("Try Again", for: .normal)
        tryAgainButton.tintColor = .white
        tryAgainButton.backgroundColor = .systemBlue
        tryAgainButton.clipsToBounds = true
        tryAgainButton.layer.cornerRadius = 5
        tryAgainButton.addTarget(self, action: #selector(tryAgainButtonPressed), for: .primaryActionTriggered)

        tryAgainButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tryAgainButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
}

//MARK: - Actions
extension NetworkErrorViewController {
    @objc func tryAgainButtonPressed() {
        delegate?.retryFetchingCategories()
    }
}
