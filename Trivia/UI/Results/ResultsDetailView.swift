//
//  ResultsDetailView.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import UIKit

class ResultsDetailView: UIView {

    private let animationDurationMultiplier = 0.02
    private let progressBarWidth: CGFloat = 15
    private let progressBarRadius: CGFloat = 95

    private let stackView = UIStackView()
    private let percentageLabel = UILabel()
    private let percentSignLabel = UILabel()
    private let fractionLabel = UILabel()
    private let progressBarShape = CAShapeLayer()

    private let results: TriviaSession.Results

    init(results: TriviaSession.Results) {
        self.results = results
        super.init(frame: .zero)

        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI Configuration
extension ResultsDetailView {
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.addArrangedSubviews(percentageLabel, fractionLabel)

        addSubview(percentSignLabel)

        configureCircles()
        configureStackView()
        configurePercentageLabel()
        configurePercentSignLabel()
        configureFractionLabel()
        configureProgressBar()
    }

    private func configureCircles() {
        let circle1Path = UIBezierPath(arcCenter: self.center, radius: 140, startAngle: 0, endAngle: 2 * .pi, clockwise: true)

        let circle1 = CAShapeLayer()
        circle1.path = circle1Path.cgPath
        circle1.fillColor = UIColor(white: 1, alpha: 0.1).cgColor
        layer.addSublayer(circle1)

        let circle2Path = UIBezierPath(arcCenter: self.center, radius: 120, startAngle: 0, endAngle: 2 * .pi, clockwise: true)

        let circle2 = CAShapeLayer()
        circle2.path = circle2Path.cgPath
        circle2.fillColor = UIColor(white: 1, alpha: 0.1).cgColor
        layer.addSublayer(circle2)
    }

    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 4)
        ])
    }

    private func configurePercentageLabel() {
        percentageLabel.text = String(results.percent)
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 72)
        percentageLabel.textColor = .white
        percentageLabel.textAlignment = .center
        percentageLabel.removeVerticalPadding()

        percentageLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        percentageLabel.layer.shadowOpacity = 0.2
        percentageLabel.layer.shadowRadius = 2
        percentageLabel.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    }

    private func configurePercentSignLabel() {
        percentSignLabel.text = "%"
        percentSignLabel.textColor = UIColor(white: 1, alpha: 0.7)
        percentSignLabel.font = UIFont.systemFont(ofSize: 24, weight: .light)
        percentSignLabel.removeVerticalPadding()
        percentSignLabel.translatesAutoresizingMaskIntoConstraints = false
        percentSignLabel.leadingAnchor.constraint(equalTo: percentageLabel.trailingAnchor).isActive = true
        percentSignLabel.topAnchor.constraint(equalTo: percentageLabel.topAnchor).isActive = true
    }

    private func configureFractionLabel() {
        fractionLabel.text = "\(results.numberCorrect) / \(results.totalQuestions)"
        fractionLabel.font = UIFont.systemFont(ofSize: 24, weight: .light)
        fractionLabel.textColor = UIColor(white: 1, alpha: 0.7)
        fractionLabel.textAlignment = .center
        fractionLabel.removeVerticalPadding()
    }

    private func configureProgressBar() {
        let circularPath = UIBezierPath(arcCenter: self.center, radius: progressBarRadius, startAngle: -.pi / 2, endAngle: 1.5 * .pi, clockwise: true)

        // Create track
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        trackShape.lineWidth = progressBarWidth
        layer.addSublayer(trackShape)

        // Create fill
        progressBarShape.path = circularPath.cgPath
        progressBarShape.fillColor = UIColor.clear.cgColor
        progressBarShape.strokeColor = UIColor.systemGreen.cgColor
        progressBarShape.lineWidth = progressBarWidth - 2
        progressBarShape.strokeStart = 0
        progressBarShape.strokeEnd = 0
        progressBarShape.lineCap = CAShapeLayerLineCap.round
        layer.addSublayer(progressBarShape)
    }
}

//MARK: - Actions
extension ResultsDetailView {
    func playProgressAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = Double(results.percent) / 100
        animation.duration = animationDurationMultiplier * Double(results.percent)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false

        progressBarShape.add(animation, forKey: "animation")
    }
}
