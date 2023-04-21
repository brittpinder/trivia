//
//  NextButton.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class CapsuleButton: UIButton {

    private let height: CGFloat = 56

    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        configure(title: title, color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI Configuration
extension CapsuleButton {
    private func configure(title: String, color: UIColor) {
        backgroundColor = color

        layer.cornerRadius = height / 2
        clipsToBounds = true

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius = 8.0
        layer.shadowColor = UIColor.black.cgColor

        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 150),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
