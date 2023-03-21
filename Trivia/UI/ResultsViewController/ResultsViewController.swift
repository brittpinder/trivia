//
//  ResultsViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import UIKit

class ResultsViewController: UIViewController {

    let resultsLabel = UILabel()
    let resultsDetailView: ResultsDetailView
    let playAgainButton = CapsuleButton(title: "Play Again", color: .systemPurple)

    init(percent: Int, numberCorrect: Int, totalQuestions: Int) {
        resultsDetailView = ResultsDetailView(percent: percent, numberCorrect: numberCorrect, totalQuestions: totalQuestions)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureResultsLabel()
        configureResultsDetailView()
        configurePlayAgainButton()
    }
}

//MARK: - UI Configuration
extension ResultsViewController {
    private func configureView() {
        view.backgroundColor = K.Colors.appBackground
        navigationItem.setHidesBackButton(true, animated: false)
    }

    private func configureResultsLabel() {
        view.addSubview(resultsLabel)

        resultsLabel.text = "Results"
        resultsLabel.font = UIFont.boldSystemFont(ofSize: 32)
        resultsLabel.textColor = .white
        resultsLabel.textAlignment = .center

        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultsLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: K.Spacing.verticalMultiplier)
        ])
    }

    private func configureResultsDetailView() {
        view.addSubview(resultsDetailView)

        NSLayoutConstraint.activate([
            resultsDetailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultsDetailView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configurePlayAgainButton() {
        view.addSubview(playAgainButton)

        playAgainButton.addTarget(self, action: #selector(playAgainButtonPressed), for: .primaryActionTriggered)

        NSLayoutConstraint.activate([
            playAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: playAgainButton.bottomAnchor, multiplier: K.Spacing.verticalMultiplier)
        ])
    }
}

//MARK: - Actions
extension ResultsViewController {
    @objc private func playAgainButtonPressed() {
        navigationController?.popToRootViewController(animated: false)
    }
}