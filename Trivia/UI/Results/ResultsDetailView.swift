//
//  ResultsDetailView.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import UIKit

class ResultsDetailView: UIView {

    let stackView = UIStackView()
    let percentageLabel = UILabel()
    let percentSignLabel = UILabel()
    let fractionLabel = UILabel()

    let percent: Int
    let numberCorrect: Int
    let totalQuestions: Int

    init(results: TriviaSession.Results) {
        self.percent = results.percent
        self.numberCorrect = results.numberCorrect
        self.totalQuestions = results.totalQuestions
        super.init(frame: .zero)

        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.addArrangedSubviews(percentageLabel, fractionLabel)

        addSubview(percentSignLabel)

        configureStackView()
        configurePercentageLabel()
        configurePercentSignLabel()
        configureFractionLabel()
    }

    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configurePercentageLabel() {
        percentageLabel.text = String(percent)
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 96)
        percentageLabel.textColor = .white
        percentageLabel.textAlignment = .center
        percentageLabel.removeVerticalPadding()
    }

    private func configurePercentSignLabel() {
        percentSignLabel.text = "%"
        percentSignLabel.textColor = .white
        percentSignLabel.font = UIFont.systemFont(ofSize: 24, weight: .light)
        percentSignLabel.removeVerticalPadding()
        percentSignLabel.translatesAutoresizingMaskIntoConstraints = false
        percentSignLabel.leadingAnchor.constraint(equalTo: percentageLabel.trailingAnchor).isActive = true
        percentSignLabel.topAnchor.constraint(equalTo: percentageLabel.topAnchor).isActive = true
    }

    private func configureFractionLabel() {
        fractionLabel.text = "\(numberCorrect) / \(totalQuestions)"
        fractionLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        fractionLabel.textColor = .white
        fractionLabel.textAlignment = .center
        fractionLabel.removeVerticalPadding()
    }
}
