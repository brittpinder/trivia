//
//  ViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class StartViewController: UIViewController {

    private let networkManager = NetworkManager()

    private let startButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureStartButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        startButton.isEnabled = true // Remove this once there is a loading screen
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
        startButton.isEnabled = false // Eventually we will go to a loading screen and this line can be removed

        networkManager.fetchQuestions(category: 10, amount: 5) { [unowned self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    if let triviaSession = TriviaSession(questionData: questions) {
                        let questionViewController = QuestionViewController(triviaSession: triviaSession)
                        self.navigationController?.pushViewController(questionViewController, animated: true)
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
