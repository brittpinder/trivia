//
//  QuestionViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class QuestionViewController: UIViewController {

    var question = "Which animal can fly?"
    var answers = ["Dog", "Cat", "Bird", "Mouse"]

    var questionLabel = UILabel()
    var answerButtonStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureQuestionLabel()
        configureAnswerButtons()
    }

}

//MARK: - UI Configuration
extension QuestionViewController {
    private func configureView() {
        view.backgroundColor = .systemBlue
    }

    private func configureQuestionLabel() {
        view.addSubview(questionLabel)

        questionLabel.text = question
        questionLabel.textColor = .white
        questionLabel.font = UIFont.boldSystemFont(ofSize: 26)
        questionLabel.numberOfLines = -1

        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: 0),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: K.Spacing.horizontalMultiplier),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: questionLabel.trailingAnchor, multiplier: K.Spacing.horizontalMultiplier)
        ])
    }

    private func configureAnswerButtons() {
        view.addSubview(answerButtonStackView)

        answerButtonStackView.axis = .vertical
        answerButtonStackView.distribution = .fill
        answerButtonStackView.spacing = 16

        answers.forEach {
            answerButtonStackView.addArrangedSubview(AnswerButton(answer: $0))
        }

        answerButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            answerButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerButtonStackView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: questionLabel.bottomAnchor, multiplier: K.Spacing.verticalMultiplier),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: answerButtonStackView.bottomAnchor, multiplier: K.Spacing.verticalMultiplier),
            answerButtonStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: K.Spacing.horizontalMultiplier),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: answerButtonStackView.trailingAnchor, multiplier: K.Spacing.horizontalMultiplier)
        ])
    }
}
