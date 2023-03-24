//
//  ViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class StartViewController: UIViewController {

    private let triviaService = TriviaService()

    private let startButton = UIButton(type: .system)

    private let loadingViewController = LoadingViewController()
    private var questionViewController: QuestionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureStartButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        loadingViewController.remove()
        questionViewController?.remove()
        questionViewController = nil
    }
}

//MARK: - UI Configuration

extension StartViewController {
    private func configureView() {
        view.backgroundColor = .white
    }

    private func configureStartButton() {
        view.addSubview(startButton)

        startButton.setTitle("Start", for: [])
        startButton.configuration = .filled()
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .primaryActionTriggered)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: - Actions
extension StartViewController {
    @objc private func startButtonPressed() {
        showLoadingScreen(onTransitionComplete: { [unowned self] finished in self.fetchQuestions()})
    }

    private func showLoadingScreen(onTransitionComplete: ((Bool) -> Void)?) {
        loadingViewController.view.alpha = 0
        add(loadingViewController)
        UIView.animate(withDuration: K.Transition.duration,
                       animations: { self.loadingViewController.view.alpha = 1 },
                       completion: onTransitionComplete)
    }

    private func hideLoadingScreen() {
        UIView.animate(withDuration: K.Transition.duration,
                       animations: { self.loadingViewController.view.alpha = 0 },
                       completion: { [unowned self] finished in self.loadingViewController.remove() })
    }

    private func showQuestionViewController() {
        guard let questionViewController else {
            assertionFailure("Trying to show QuestionViewController when it hasn't been initialized!")
            return
        }

        questionViewController.view.alpha = 0
        add(questionViewController)
        UIView.animate(withDuration: K.Transition.duration,
                       animations: { questionViewController.view.alpha = 1 },
                       completion: nil)
    }

    private func fetchQuestions() {
        triviaService.fetchQuestions(category: 10, amount: 5) { [unowned self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    if let triviaSession = TriviaSession(questionData: questions) {
                        self.questionViewController = QuestionViewController(triviaSession: triviaSession)
                        self.hideLoadingScreen()
                        self.showQuestionViewController()
                    } else {
                        // TODO: Handle case where failed to create Trivia Session (perhaps due to corrupt data)
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
}
