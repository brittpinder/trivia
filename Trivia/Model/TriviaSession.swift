//
//  TriviaSession.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import Foundation

struct TriviaSession {
    private let questions: [Question] = [Question(question: "Which animal can fly?", answers: ["Dolphin", "Eagle", "Dog", "Elephant"], correctIndex: 1)!,
                                 Question(question: "What is the capital of Canada?", answers: ["Toronto", "Ontario", "Ottawa", "Vancouver"], correctIndex: 2)!,
                                 Question(question: "Which is a prime number?", answers: ["3", "4", "6", "8"], correctIndex: 0)!]

    private var questionIndex = -1

    mutating func getNextQuestion() -> Question? {
        questionIndex += 1

        if questionIndex >= questions.count {
            return nil
        }

        return questions[questionIndex]
    }
}
