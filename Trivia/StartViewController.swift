//
//  ViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class StartViewController: UIViewController {

    private let startButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureStartButton()
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
        navigationController?.pushViewController(QuestionViewController(), animated: true)
    }
}
