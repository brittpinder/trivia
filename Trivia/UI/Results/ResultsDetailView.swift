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
    let fractionLabel = UILabel()

    let percent: Int
    let numberCorrect: Int
    let totalQuestions: Int

    init(percent: Int, numberCorrect: Int, totalQuestions: Int) {
        self.percent = percent
        self.numberCorrect = numberCorrect
        self.totalQuestions = totalQuestions
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

        configureStackView()
        configurePercentageLabel()
        configureFractionLabel()
    }

    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configurePercentageLabel() {
        percentageLabel.attributedText = makePercentageAttributed(percentage: percent)
        percentageLabel.textColor = .white
        percentageLabel.textAlignment = .center
        percentageLabel.removeVerticalPadding()
    }

    private func configureFractionLabel() {
        fractionLabel.text = "\(numberCorrect) \\ \(totalQuestions)"
        fractionLabel.font = UIFont.systemFont(ofSize: 28)
        fractionLabel.textColor = .white
        fractionLabel.textAlignment = .center
        fractionLabel.removeVerticalPadding()
    }

    private func makePercentageAttributed(percentage: Int) -> NSMutableAttributedString {
        let numberFont = UIFont.boldSystemFont(ofSize: 96)
        let percentFont = UIFont.systemFont(ofSize: 28)

        let numberString = NSMutableAttributedString(string: String(percentage), attributes: [.font: numberFont])

        let baselineOffset = (numberFont.capHeight - percentFont.capHeight)
        let percentString = NSAttributedString(string: "%", attributes: [.font: percentFont, .baselineOffset: baselineOffset])

        numberString.append(percentString)
        return numberString
    }
}
