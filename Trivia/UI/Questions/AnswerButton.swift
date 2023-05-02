//
//  AnswerButton.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class AnswerButton: UIButton {

    let index: Int

    enum ButtonState {
        case normal, correct, incorrect, highlightCorrect

        var backgroundColor: UIColor {
            switch self {
            case .normal: return .white
            case .correct: return K.Colors.correctAnswer
            case .incorrect: return K.Colors.incorrectAnswer
            case .highlightCorrect: return K.Colors.correctAnswer
            }
        }

        var titleColor: UIColor {
            switch self {
            case .normal: return K.Colors.background
            case .correct: return .white
            case .incorrect: return .white
            case .highlightCorrect: return .white
            }
        }

        var icon: UIImage? {
            switch self {
            case .normal: return nil
            case .correct: return UIImage(systemName: "checkmark")
            case .incorrect: return UIImage(systemName: "xmark")
            case .highlightCorrect: return nil
            }
        }
    }
    private var buttonState = ButtonState.normal

    private var icon = UIImageView()

    init(answer: String, index: Int) {
        self.index = index
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
        layer.cornerRadius = 10
        clipsToBounds = true

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius = 8.0
        layer.shadowColor = UIColor.black.cgColor

        setTitle(answer, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = -1
        titleLabel?.textAlignment = .center

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 64).isActive = true
        titleLabel?.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        addSubview(icon)

        icon.tintColor = .white

        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            icon.heightAnchor.constraint(equalToConstant: 20)
        ])

        setState(.normal)
    }

    func setState(_ state: ButtonState) {
        self.buttonState = state

        setTitleColor(state.titleColor, for: .normal)

        if let iconImage = state.icon {
            icon.isHidden = false
            icon.image = iconImage
        } else {
            icon.isHidden = true
        }

        UIViewPropertyAnimator(duration: K.Animations.answerColorChangeDuration, curve: .easeInOut) {
            self.backgroundColor = state.backgroundColor
        }.startAnimation()
    }
}
