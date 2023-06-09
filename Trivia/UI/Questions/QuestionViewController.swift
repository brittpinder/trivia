//
//  QuestionViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit
import AVFoundation

protocol QuestionViewControllerDelegate: AnyObject {
    func didExitRound()
    func didFinishRound()
}

class QuestionViewController: UIViewController {

    private var triviaRound: TriviaRound
    private var totalQuestions: Int
    private var questionNumber = 0

    weak var delegate: QuestionViewControllerDelegate?

    private var exitButton = ExitButton()
    private var progressLabel = UILabel()
    private var questionLabel = UILabel()
    private var answerButtons = [AnswerButton]()
    private var answerButtonStackView = UIStackView()
    private var nextButton = CapsuleButton(title: "Next", color: K.Colors.accent)

    private var correctSoundPlayer: AVAudioPlayer?
    private var incorrectSoundPlayer: AVAudioPlayer?
    private let hapticFeedbackGenerator = UINotificationFeedbackGenerator()

    private var questionSlideOffset: CGFloat {
        return (view.getScreenWidth() ?? 500.0) + 50.0
    }

    lazy private var exitAlert: UIAlertController = {
        let alert = UIAlertController(title: "Exit Round", message: "Are you sure you want to exit this trivia round?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { [unowned self] (action) in self.exitTriviaRound() }))
        alert.addAction(UIAlertAction(title: "Keep Playing", style: .default, handler: nil))
        return alert
    }()

    init(triviaRound: TriviaRound) {
        self.triviaRound = triviaRound
        totalQuestions = triviaRound.numberOfQuestions
        super.init(nibName: nil, bundle: nil)
        loadSoundEffects()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        hapticFeedbackGenerator.prepare()
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if let question = triviaRound.getNextQuestion() {
            questionNumber += 1
            displayQuestion(question)
        } else {
            delegate?.didFinishRound()
        }
    }

    private func displayQuestion(_ question: Question) {
        progressLabel.text = "Question \(questionNumber) of \(totalQuestions)"
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
            answerButton.transform = CGAffineTransform(translationX: questionSlideOffset, y: 0)
        }

        slideQuestionIn()
        nextButton.isHidden = true
    }

    private func exitTriviaRound() {
        delegate?.didExitRound()
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

        questionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }

    private func configureAnswerButtons() {
        answerButtonStackView.axis = .vertical
        answerButtonStackView.distribution = .fill
        answerButtonStackView.spacing = 16

        answerButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            answerButtonStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: K.Spacing.marginMultiplier),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: answerButtonStackView.trailingAnchor, multiplier: K.Spacing.marginMultiplier),
            answerButtonStackView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: questionLabel.bottomAnchor, multiplier: K.Spacing.verticalMultiplier)
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

        let result = triviaRound.submitAnswer(answerIndex: sender.index)

        if result.isCorrect {
            sender.setState(.correct)
            playCorrectSound()
        } else {
            sender.setState(.incorrect)
            playIncorrectSound()

            guard result.correctIndex >= 0 && result.correctIndex < answerButtons.count else {
                assertionFailure("Correct index is out of range!")
                return
            }
            answerButtons[result.correctIndex].setState(.highlightCorrect)
        }
    }

    @objc private func nextButtonPressed() {
        nextButton.isHidden = true
        slideQuestionOut()
    }

    @objc private func exitButtonPressed() {
        present(exitAlert, animated: true, completion: nil)
    }
}

//MARK: - Sound Effects
extension QuestionViewController {
    private func loadSoundEffects() {
        guard let url = Bundle.main.url(forResource: K.Sounds.correct, withExtension: ".mp3") else {
            assertionFailure("Failed to find sound effect!")
            return
        }
        correctSoundPlayer = try? AVAudioPlayer(contentsOf: url)

        guard let url = Bundle.main.url(forResource: K.Sounds.incorrect, withExtension: ".mp3") else {
            assertionFailure("Failed to find sound effect!")
            return
        }

        incorrectSoundPlayer = try? AVAudioPlayer(contentsOf: url)
        incorrectSoundPlayer?.volume = 0.4
    }

    func playCorrectSound() {
        correctSoundPlayer?.play()
        hapticFeedbackGenerator.notificationOccurred(.success)
    }

    func playIncorrectSound() {
        incorrectSoundPlayer?.play()
    }
}

//MARK: - Animations
extension QuestionViewController {
    private func slideQuestionOut() {
        UIView.animate(withDuration: K.Animations.questionSlideDuration + (CGFloat(answerButtons.count - 1) * K.Animations.questionSlideDelay),
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn,
                       animations: {
            self.questionLabel.transform = CGAffineTransform(translationX: self.questionSlideOffset, y: 0)
            self.questionLabel.alpha = 0
        })

        for (index, answerButton) in answerButtons.enumerated() {
            UIView.animate(withDuration: K.Animations.questionSlideDuration,
                           delay: Double(index + 1) * K.Animations.questionSlideDelay,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn,
                           animations: {
                answerButton.transform = CGAffineTransform(translationX: -self.questionSlideOffset, y: 0)
            }) { (_) in
                if index == self.answerButtons.count - 1 {
                    self.goToNextQuestion()
                }
            }
        }
    }

    private func slideQuestionIn() {
        questionLabel.transform = CGAffineTransform(translationX: -self.questionSlideOffset, y: 0)
        questionLabel.alpha = 0
        UIView.animate(withDuration: K.Animations.questionSlideDuration + (CGFloat(answerButtons.count - 1) * K.Animations.questionSlideDelay),
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn,
                       animations: {
            self.questionLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.questionLabel.alpha = 1
        })

        for (index, answerButton) in answerButtons.enumerated() {
            UIView.animate(withDuration: K.Animations.questionSlideDuration,
                           delay: Double(index + 1) * K.Animations.questionSlideDelay,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn,
                           animations: {
                answerButton.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}
