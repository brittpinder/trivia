//
//  TriviaRound.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import Foundation

class TriviaRound {

    struct Results: Equatable {
        let percentCorrect: Int
        let numberCorrect: Int
        let numberOfQuestions: Int
    }

    private let questions: [Question]
    private var questionIndex = -1
    private var currentQuestion: Question? = nil
    private(set) var numberCorrect = 0

    init?(questionData: [QuestionDto]) {
        self.questions = QuestionUtil.getQuestions(from: questionData)

        if self.questions.isEmpty {
            return nil
        }
    }

    var numberOfQuestions: Int {
        return questions.count
    }

    var percentCorrect: Int {
        let percent = Float(numberCorrect) / Float(numberOfQuestions) * 100
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
                numberCorrect += 1
                return (true, currentQuestion.correctIndex)
            } else {
                return (false, currentQuestion.correctIndex)
            }
        }
        assertionFailure("Attempting to submit answer when there is no current question!")
        return (false, -1)
    }

    func getResults() -> Results {
        return Results(percentCorrect: percentCorrect, numberCorrect: numberCorrect, numberOfQuestions: numberOfQuestions)
    }
}
