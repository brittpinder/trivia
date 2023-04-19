//
//  NetworkErrorViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-04-19.
//

import UIKit

protocol NetworkErrorViewControllerDelegate: AnyObject {
    func tryFetchingCategoriesAgain()
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
    func configureView() {
        view.backgroundColor = .white

        view.addSubview(stackView)

        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: K.Spacing.horizontalMultiplier),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: K.Spacing.horizontalMultiplier)
        ])

        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(tryAgainButton)

        errorLabel.text = "Something went wrong. Please check your internet connection and try again."
        errorLabel.numberOfLines = -1
        errorLabel.textAlignment = .center

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
        delegate?.tryFetchingCategoriesAgain()
    }
}
