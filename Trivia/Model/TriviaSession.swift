//
//  TriviaSession.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import Foundation

class TriviaSession {
    private let questions: [Question]
    private var questionIndex = -1
    private var currentQuestion: Question? = nil
    private(set) var totalCorrect = 0

    init?(questionData: [QuestionDto]) {
        self.questions = QuestionUtil.getQuestions(from: questionData)

        if self.questions.isEmpty {
            return nil
        }
    }

    var numberOfQuestions: Int {
        return questions.count
    }

    var correctPercentage: Int {
        let percent = Float(totalCorrect) / Float(numberOfQuestions) * 100
        return Int(percent.rounded(.toNearestOrAwayFromZero))
    }

    func getNextQuestion() -> Question? {
        questionIndex += 1

        if questionIndex >= questions.count {
            currentQuestion = nil
        } else {
            currentQuestion = questions[questionIndex]
        }

        return currentQuestion
    }

    func submitAnswer(answerIndex: Int) -> (isCorrect: Bool, correctIndex: Int) {
        if let currentQuestion {
            if answerIndex == currentQuestion.correctIndex {
                totalCorrect += 1
                return (true, currentQuestion.correctIndex)
            } else {
                return (false, currentQuestion.correctIndex)
            }
        }
        assertionFailure("Attempting to submit answer when there is no current question!")
        return (false, -1)
    }
}
