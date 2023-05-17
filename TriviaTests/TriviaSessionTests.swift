//
//  TriviaSessionTests.swift
//  TriviaTests
//
//  Created by Brittany Pinder on 2023-05-16.
//

import XCTest
@testable import Trivia

final class TriviaSessionTests: XCTestCase {

    let validQuestions = [
        QuestionDto(category: "Games", question: "How many dots are on a die?", correctAnswer: "21", incorrectAnswers: ["25", "18", "6"]),
        QuestionDto(category: "Geography", question: "What is the capital of Canada?", correctAnswer: "Ottawa", incorrectAnswers: ["Toronto", "Ontario", "Vancouver"]),
        QuestionDto(category: "Science", question: "Au on the Periodic Table refers to which element?", correctAnswer: "Gold", incorrectAnswers: ["Oxygen", "Silver", "Nickel"])
    ]

    func calculateCorrectPercentage(totalCorrect: Int, numberOfQuestions: Int) -> Int {
        let percent = Float(totalCorrect) / Float(numberOfQuestions) * 100
        return Int(percent.rounded(.toNearestOrAwayFromZero))
    }

    func testTriviaSessionWithPerfectScore() {
        guard let triviaSession = TriviaSession(questionData: validQuestions) else {
            XCTFail()
            return
        }

        XCTAssertEqual(triviaSession.numberOfQuestions, validQuestions.count)

        for i in 0..<validQuestions.count {
            XCTAssertEqual(triviaSession.totalCorrect, i)
            XCTAssertEqual(triviaSession.correctPercentage, calculateCorrectPercentage(totalCorrect: i, numberOfQuestions: validQuestions.count))

            guard let currentQuestion = triviaSession.getNextQuestion() else {
                XCTFail()
                return
            }

            XCTAssertEqual(currentQuestion.question, validQuestions[i].question)

            let answers = [validQuestions[i].correctAnswer] + validQuestions[i].incorrectAnswers
            XCTAssertEqual(currentQuestion.answers.count, answers.count)
            for answer in answers {
                XCTAssertTrue(currentQuestion.answers.contains(answer))
            }

            let result = triviaSession.submitAnswer(answerIndex: currentQuestion.correctIndex)
            XCTAssertEqual(result.isCorrect, true)
            XCTAssertEqual(result.correctIndex, currentQuestion.correctIndex)
        }

        let currentQuestion = triviaSession.getNextQuestion()
        XCTAssertNil(currentQuestion)
        XCTAssertEqual(triviaSession.totalCorrect, validQuestions.count)
        XCTAssertEqual(triviaSession.correctPercentage, 100)
        XCTAssertEqual(triviaSession.getResults(), TriviaSession.Results(percent: 100, numberCorrect: validQuestions.count, totalQuestions: validQuestions.count))
    }

    func testTriviaSessionWithNoCorrectAnswers() {
        guard let triviaSession = TriviaSession(questionData: validQuestions) else {
            XCTFail()
            return
        }

        XCTAssertEqual(triviaSession.numberOfQuestions, validQuestions.count)

        for i in 0..<validQuestions.count {
            XCTAssertEqual(triviaSession.totalCorrect, 0)
            XCTAssertEqual(triviaSession.correctPercentage, 0)

            guard let currentQuestion = triviaSession.getNextQuestion() else {
                XCTFail()
                return
            }

            XCTAssertEqual(currentQuestion.question, validQuestions[i].question)

            let answers = [validQuestions[i].correctAnswer] + validQuestions[i].incorrectAnswers
            XCTAssertEqual(currentQuestion.answers.count, answers.count)
            for answer in answers {
                XCTAssertTrue(currentQuestion.answers.contains(answer))
            }

            let result = triviaSession.submitAnswer(answerIndex: -1)
            XCTAssertEqual(result.isCorrect, false)
            XCTAssertEqual(result.correctIndex, currentQuestion.correctIndex)
        }

        let currentQuestion = triviaSession.getNextQuestion()
        XCTAssertNil(currentQuestion)
        XCTAssertEqual(triviaSession.totalCorrect, 0)
        XCTAssertEqual(triviaSession.correctPercentage, 0)
        XCTAssertEqual(triviaSession.getResults(), TriviaSession.Results(percent: 0, numberCorrect: 0, totalQuestions: validQuestions.count))
    }

    func testTriviaSessionWithSomeCorrectAnswers() {
        guard let triviaSession = TriviaSession(questionData: validQuestions) else {
            XCTFail()
            return
        }

        XCTAssertEqual(triviaSession.numberOfQuestions, validQuestions.count)

        var totalCorrect = 0
        for i in 0..<validQuestions.count {
            XCTAssertEqual(triviaSession.totalCorrect, totalCorrect)
            XCTAssertEqual(triviaSession.correctPercentage, calculateCorrectPercentage(totalCorrect: totalCorrect, numberOfQuestions: validQuestions.count))

            guard let currentQuestion = triviaSession.getNextQuestion() else {
                XCTFail()
                return
            }

            XCTAssertEqual(currentQuestion.question, validQuestions[i].question)

            let answers = [validQuestions[i].correctAnswer] + validQuestions[i].incorrectAnswers
            XCTAssertEqual(currentQuestion.answers.count, answers.count)
            for answer in answers {
                XCTAssertTrue(currentQuestion.answers.contains(answer))
            }

            let guessCorrectly = i % 2 == 0
            let result = triviaSession.submitAnswer(answerIndex: guessCorrectly ? currentQuestion.correctIndex : -1)
            XCTAssertEqual(result.isCorrect, guessCorrectly)
            XCTAssertEqual(result.correctIndex, currentQuestion.correctIndex)
            totalCorrect += guessCorrectly ? 1 : 0
        }

        let currentQuestion = triviaSession.getNextQuestion()
        XCTAssertNil(currentQuestion)
        XCTAssertEqual(triviaSession.totalCorrect, totalCorrect)
        XCTAssertEqual(triviaSession.correctPercentage, calculateCorrectPercentage(totalCorrect: totalCorrect, numberOfQuestions: validQuestions.count))
        XCTAssertEqual(triviaSession.getResults(), TriviaSession.Results(percent: triviaSession.correctPercentage, numberCorrect: triviaSession.totalCorrect, totalQuestions: validQuestions.count))
    }

    func testTriviaSessionIsNilWithNoQuestions() {
        XCTAssertNil(TriviaSession(questionData: []))
    }

}
