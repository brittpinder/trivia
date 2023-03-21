//
//  QuestionViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class QuestionViewController: UIViewController {

    var triviaSession = TriviaSession()

    var questionLabel = UILabel()
    var answerButtons = [AnswerButton]()
    var answerButtonStackView = UIStackView()
    var nextButton = CapsuleButton(title: "Next", color: .systemPurple)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureQuestionLabel()
        configureAnswerButtons()
        configureNextButton()

        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if let question = triviaSession.getNextQuestion() {
            displayQuestion(question)
        } else {
            goToResults()
        }
    }

    private func goToResults() {
        let resultsViewController = ResultsViewController(percent: triviaSession.correctPercentage, numberCorrect: triviaSession.totalCorrect, totalQuestions: triviaSession.numberOfQuestions)
        navigationController?.pushViewController(resultsViewController, animated: true)
    }

    private func displayQuestion(_ question: Question) {
        questionLabel.text = question.question

        answerButtons.removeAll(keepingCapacity: true)
        for subview in answerButtonStackView.arrangedSubviews {
            answerButtonStackView.removeArrangedSubview(view)
            subview.removeFromSuperview()
        }

        for (index, answer) in question.answers.enumerated() {
            let answerButton = AnswerButton(answer: answer, index: index)
            answerButton.addTarget(self, action: #selector(answerSelected), for: .primaryActionTriggered)
            answerButtons.append(answerButton)
            answerButtonStackView.addArrangedSubview(answerButton)
        }

        nextButton.isHidden = true
    }
}

//MARK: - UI Configuration
extension QuestionViewController {
    private func configureView() {
        view.backgroundColor = K.Colors.appBackground
        navigationItem.setHidesBackButton(true, animated: false)
    }

    private func configureQuestionLabel() {
        view.addSubview(questionLabel)

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

        answerButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            answerButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerButtonStackView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: questionLabel.bottomAnchor, multiplier: K.Spacing.verticalMultiplier),
            answerButtonStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: K.Spacing.horizontalMultiplier),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: answerButtonStackView.trailingAnchor, multiplier: K.Spacing.horizontalMultiplier)
        ])
    }

    private func configureNextButton() {
        view.addSubview(nextButton)

        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .primaryActionTriggered)

        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalToSystemSpacingBelow: answerButtonStackView.bottomAnchor, multiplier: K.Spacing.verticalMultiplier),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: K.Spacing.verticalMultiplier),
        ])
    }
}

//MARK: - Actions
extension QuestionViewController {
    @objc private func answerSelected(_ sender: AnswerButton) {
        let result = triviaSession.submitAnswer(answerIndex: sender.index)

        if result.isCorrect {
            sender.setState(.correct)
        } else {
            sender.setState(.incorrect)

            assert(result.correctIndex >= 0 && result.correctIndex < answerButtons.count, "Correct Index is out of range!")
            answerButtons[result.correctIndex].setState(.highlightCorrect)
        }

        answerButtons.forEach { $0.isEnabled = false }
        nextButton.isHidden = false
    }

    @objc private func nextButtonPressed() {
        goToNextQuestion()
    }
}
