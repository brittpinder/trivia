//
//  AnswerButton.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class AnswerButton: UIButton {

    init(answer: String) {
        super.init(frame: .zero)

        configureView(with: answer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI Configuration
extension AnswerButton {
    private func configureView(with answer: String) {
        backgroundColor = .white

        layer.cornerRadius = 10
        clipsToBounds = true

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius = 8.0
        layer.shadowColor = UIColor.black.cgColor

        setTitle(answer, for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
}
