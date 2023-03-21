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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.addArrangedSubview(percentageLabel)
        stackView.addArrangedSubview(fractionLabel)

        stackView.axis = .vertical
        stackView.spacing = 16

        percentageLabel.attributedText = makePercentageAttributed(percentage: 86)
        percentageLabel.textColor = .white
        percentageLabel.textAlignment = .center
        percentageLabel.removeVerticalPadding()

        fractionLabel.text = "28 / 30"
        fractionLabel.font = UIFont.systemFont(ofSize: 28)
        fractionLabel.textColor = .white
        fractionLabel.textAlignment = .center
        fractionLabel.removeVerticalPadding()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

    func makePercentageAttributed(percentage: Int) -> NSMutableAttributedString {
        let numberFont = UIFont.boldSystemFont(ofSize: 96)
        let percentFont = UIFont.systemFont(ofSize: 28)

        let numberString = NSMutableAttributedString(string: String(percentage), attributes: [.font: numberFont])

        let baselineOffset = (numberFont.capHeight - percentFont.capHeight)
        let percentString = NSAttributedString(string: "%", attributes: [.font: percentFont, .baselineOffset: baselineOffset])

        numberString.append(percentString)
        return numberString
    }
}
