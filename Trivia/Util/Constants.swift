//
//  Constants.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

struct K {
    struct Spacing {
        static let marginMultiplier: CGFloat = 3.0
        static let verticalMultiplier: CGFloat = 4.0
    }

    struct Colors {
        static let background: UIColor = .systemBlue
        static let accent: UIColor = UIColor(red: 95/255, green: 39/255, blue: 205/255, alpha: 1.0)
        static let correctAnswer: UIColor = .systemGreen
        static let incorrectAnswer: UIColor = UIColor(red: 238/255, green: 82/255, blue: 83/255, alpha: 1.0)
        static let categoryColors: [UIColor] = [.systemBlue, .systemMint, accent, .systemPink, .systemOrange]
    }

    struct Transition {
        static let duration: CGFloat = 0.4
    }

    struct Animations {
        static let questionSlideDuration: CGFloat = 0.6
        static let questionSlideDelay: CGFloat = 0.12
        static let answerColorChangeDuration: CGFloat = 0.15
    }

    struct Settings {
        static let numQuestions: Int = 10
    }
}
