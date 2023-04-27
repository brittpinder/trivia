//
//  QuestionViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

protocol QuestionViewControllerDelegate: AnyObject {
    func exitRound()
    func lastQuestionWasAnswered()
}

class QuestionViewController: UIViewController {

    var triviaSession: TriviaSession
    var totalQuestions: Int
    var questionIndex = 0

    weak var delegate: QuestionViewControllerDelegate?

    var exitButton = ExitButton()
    var progressLabel = UILabel()
    var questionLabel = UILabel()
    var answerButtons = [AnswerButton]()
    var answerButtonStackView = UIStackView()
    var nextButton = CapsuleButton(title: "Next", color: K.Colors.accent)

    private var answerSlideOffset: CGFloat {
        return (view.getScreenWidth() ?? 500.0) + 50.0
    }

    lazy var exitAlert: UIAlertController = {
        let alert = UIAlertController(title: "Exit Round", message: "Are you sure you want to exit this trivia round?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { [unowned self] (action) in self.exitTriviaSession() }))
        alert.addAction(UIAlertAction(title: "Keep Playing", style: .default, handler: nil))
        return alert
    }()

    init(triviaSession: TriviaSession) {
        self.triviaSession = triviaSession
        totalQuestions = triviaSession.numberOfQuestions
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if let question = triviaSession.getNextQuestion() {
            questionIndex += 1
            displayQuestion(question)
        } else {
            delegate?.lastQuestionWasAnswered()
        }
    }

    private func displayQuestion(_ question: Question) {
        progressLabel.text = "Question \(questionIndex) of \(totalQuestions)"
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
            answerButton.transform = CGAffineTransform(translationX: answerSlideOffset, y: 0)
        }

        slideAnswersIn()
        nextButton.isHidden = true
    }

    private func exitTriviaSession() {
        delegate?.exitRound()
    }
}

//MARK: - UI Configuration
extension QuestionViewController {
    private func configureView() {
        view.backgroundColor = K.Colors.background
        navigationItem.setHidesBackButton(true, animated: false)

        view.addSubviews(exitButton, progressLabel, questionLabel, answerButtonStackView, nextButton)

        configureExitButton()
        configureProgressLabel()
        configureQuestionLabel()
        configureAnswerButtons()
        configureNextButton()
    }

    private func configureExitButton() {
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .primaryActionTriggered)

        NSLayoutConstraint.activate([
            exitButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: K.Spacing.marginMultiplier),
            exitButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: K.Spacing.marginMultiplier)
        ])
    }

    private func configureProgressLabel() {
        progressLabel.textColor = .white
        progressLabel.font = .systemFont(ofSize: 18, weight: .light)

        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: K.Spacing.marginMultiplier),
            progressLabel.topAnchor.constraint(equalToSystemSpacingBelow: exitButton.bottomAnchor, multiplier: K.Spacing.verticalMultiplier)
        ])
    }

    private func configureQuestionLabel() {
        questionLabel.textColor = .white
        questionLabel.font = UIFont.boldSystemFont(ofSize: 26)
        questionLabel.numberOfLines = -1
        questionLabel.adjustsFontSizeToFitWidth = true

        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: K.Spacing.marginMultiplier),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: questionLabel.trailingAnchor, multiplier: K.Spacing.marginMultiplier),
            questionLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8)
        ])
    }

    private func configureAnswerButtons() {
        answerButtonStackView.axis = .vertical
        answerButtonStackView.distribution = .fill
        answerButtonStackView.spacing = 16

        answerButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            answerButtonStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: K.Spacing.marginMultiplier),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: answerButtonStackView.trailingAnchor, multiplier: K.Spacing.marginMultiplier)
        ])
    }

    private func configureNextButton() {
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .primaryActionTriggered)

        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalToSystemSpacingBelow: answerButtonStackView.bottomAnchor, multiplier: K.Spacing.verticalMultiplier),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: K.Spacing.verticalMultiplier)
        ])
    }
}

//MARK: - Actions
extension QuestionViewController {
    @objc private func answerSelected(_ sender: AnswerButton) {
        answerButtons.forEach { $0.isEnabled = false }
        nextButton.isHidden = false

        let result = triviaSession.submitAnswer(answerIndex: sender.index)

        if result.isCorrect {
            sender.setState(.correct)
        } else {
            sender.setState(.incorrect)

            guard result.correctIndex >= 0 && result.correctIndex < answerButtons.count else {
                assertionFailure("Correct index is out of range!")
                return
            }
            answerButtons[result.correctIndex].setState(.highlightCorrect)
        }
    }

    private func slideAnswersOut() {
        for (index, answerButton) in answerButtons.enumerated() {
            UIView.animate(withDuration: K.Animations.answerSlideDuration,
                           delay: Double(index) * K.Animations.answerSlideDelay,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn,
                           animations: {
                answerButton.transform = CGAffineTransform(translationX: -self.answerSlideOffset, y: 0)
            }) { (_) in
                if index == self.answerButtons.count - 1 {
                    self.goToNextQuestion()
                }
            }
        }
    }

    private func slideAnswersIn() {
        for (index, answerButton) in answerButtons.enumerated() {
            UIView.animate(withDuration: K.Animations.answerSlideDuration,
                           delay: Double(index) * K.Animations.answerSlideDelay,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn,
                           animations: {
                answerButton.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }

    @objc private func nextButtonPressed() {
        nextButton.isHidden = true
        slideAnswersOut()
    }

    @objc private func exitButtonPressed() {
        present(exitAlert, animated: true, completion: nil)
    }
}
