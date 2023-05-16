//
//  Question.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import Foundation

struct Question {
    let question: String
    let answers: [String]
    let correctIndex: Int

    init?(question: String, answers: [String], correctIndex: Int) {
        guard !question.isEmpty, !answers.isEmpty, correctIndex >= 0, correctIndex < answers.count else {
            return nil
        }

        for answer in answers {
            if answer.isEmpty {
                return nil
            }
        }

        self.question = question
        self.answers = answers
        self.correctIndex = correctIndex
    }
}
