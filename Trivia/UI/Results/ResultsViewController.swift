//
//  ResultsViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import UIKit

protocol ResultsViewControllerDelegate: AnyObject {
    func playAgainPressed()
}

class ResultsViewController: UIViewController {

    let resultsLabel = UILabel()
    let resultsDetailView: ResultsDetailView
    let playAgainButton = CapsuleButton(title: "Play Again", color: K.Colors.accent)

    weak var delegate: ResultsViewControllerDelegate?

    init(triviaSession: TriviaSession) {
        resultsDetailView = ResultsDetailView(percent: triviaSession.correctPercentage, numberCorrect: triviaSession.totalCorrect, totalQuestions: triviaSession.numberOfQuestions)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

//MARK: - UI Configuration
extension ResultsViewController {
    private func configureView() {
        view.backgroundColor = K.Colors.background
        navigationItem.setHidesBackButton(true, animated: false)

        view.addSubviews(resultsLabel, resultsDetailView, playAgainButton)

        configureResultsLabel()
        configureResultsDetailView()
        configurePlayAgainButton()
    }

    private func configureResultsLabel() {
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
        NSLayoutConstraint.activate([
            resultsDetailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultsDetailView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configurePlayAgainButton() {
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
        delegate?.playAgainPressed()
    }
}
