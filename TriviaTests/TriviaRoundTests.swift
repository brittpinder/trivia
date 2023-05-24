//
//  TriviaRoundTests.swift
//  TriviaTests
//
//  Created by Brittany Pinder on 2023-05-16.
//

import XCTest
@testable import Trivia

final class TriviaRoundTests: XCTestCase {

    let validQuestions = [
        QuestionDto(category: "Games", question: "How many dots are on a die?", correctAnswer: "21", incorrectAnswers: ["25", "18", "6"]),
        QuestionDto(category: "Geography", question: "What is the capital of Canada?", correctAnswer: "Ottawa", incorrectAnswers: ["Toronto", "Ontario", "Vancouver"]),
        QuestionDto(category: "Science", question: "Au on the Periodic Table refers to which element?", correctAnswer: "Gold", incorrectAnswers: ["Oxygen", "Silver", "Nickel"])
    ]

    func calculateCorrectPercentage(totalCorrect: Int, numberOfQuestions: Int) -> Int {
        let percent = Float(totalCorrect) / Float(numberOfQuestions) * 100
        return Int(percent.rounded(.toNearestOrAwayFromZero))
    }

    func testTriviaRoundWithPerfectScore() {
        guard let triviaRound = TriviaRound(questionData: validQuestions) else {
            XCTFail()
            return
        }

        XCTAssertEqual(triviaRound.numberOfQuestions, validQuestions.count)

        for i in 0..<validQuestions.count {
            XCTAssertEqual(triviaRound.numberCorrect, i)
            XCTAssertEqual(triviaRound.percentCorrect, calculateCorrectPercentage(totalCorrect: i, numberOfQuestions: validQuestions.count))

            guard let currentQuestion = triviaRound.getNextQuestion() else {
                XCTFail()
                return
            }

            XCTAssertEqual(currentQuestion.question, validQuestions[i].question)

            let answers = [validQuestions[i].correctAnswer] + validQuestions[i].incorrectAnswers
            XCTAssertEqual(currentQuestion.answers.count, answers.count)
            for answer in answers {
                XCTAssertTrue(currentQuestion.answers.contains(answer))
            }

            let result = triviaRound.submitAnswer(answerIndex: currentQuestion.correctIndex)
            XCTAssertEqual(result.isCorrect, true)
            XCTAssertEqual(result.correctIndex, currentQuestion.correctIndex)
        }

        let currentQuestion = triviaRound.getNextQuestion()
        XCTAssertNil(currentQuestion)
        XCTAssertEqual(triviaRound.numberCorrect, validQuestions.count)
        XCTAssertEqual(triviaRound.percentCorrect, 100)
        XCTAssertEqual(triviaRound.getResults(), TriviaRound.Results(percentCorrect: 100, numberCorrect: validQuestions.count, numberOfQuestions: validQuestions.count))
    }

    func testTriviaRoundWithNoCorrectAnswers() {
        guard let triviaRound = TriviaRound(questionData: validQuestions) else {
            XCTFail()
            return
        }

        XCTAssertEqual(triviaRound.numberOfQuestions, validQuestions.count)

        for i in 0..<validQuestions.count {
            XCTAssertEqual(triviaRound.numberCorrect, 0)
            XCTAssertEqual(triviaRound.percentCorrect, 0)

            guard let currentQuestion = triviaRound.getNextQuestion() else {
                XCTFail()
                return
            }

            XCTAssertEqual(currentQuestion.question, validQuestions[i].question)

            let answers = [validQuestions[i].correctAnswer] + validQuestions[i].incorrectAnswers
            XCTAssertEqual(currentQuestion.answers.count, answers.count)
            for answer in answers {
                XCTAssertTrue(currentQuestion.answers.contains(answer))
            }

            let result = triviaRound.submitAnswer(answerIndex: -1)
            XCTAssertEqual(result.isCorrect, false)
            XCTAssertEqual(result.correctIndex, currentQuestion.correctIndex)
        }

        let currentQuestion = triviaRound.getNextQuestion()
        XCTAssertNil(currentQuestion)
        XCTAssertEqual(triviaRound.numberCorrect, 0)
        XCTAssertEqual(triviaRound.percentCorrect, 0)
        XCTAssertEqual(triviaRound.getResults(), TriviaRound.Results(percentCorrect: 0, numberCorrect: 0, numberOfQuestions: validQuestions.count))
    }

    func testTriviaRoundWithSomeCorrectAnswers() {
        guard let triviaRound = TriviaRound(questionData: validQuestions) else {
            XCTFail()
            return
        }

        XCTAssertEqual(triviaRound.numberOfQuestions, validQuestions.count)

        var totalCorrect = 0
        for i in 0..<validQuestions.count {
            XCTAssertEqual(triviaRound.numberCorrect, totalCorrect)
            XCTAssertEqual(triviaRound.percentCorrect, calculateCorrectPercentage(totalCorrect: totalCorrect, numberOfQuestions: validQuestions.count))

            guard let currentQuestion = triviaRound.getNextQuestion() else {
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
            let result = triviaRound.submitAnswer(answerIndex: guessCorrectly ? currentQuestion.correctIndex : -1)
            XCTAssertEqual(result.isCorrect, guessCorrectly)
            XCTAssertEqual(result.correctIndex, currentQuestion.correctIndex)
            totalCorrect += guessCorrectly ? 1 : 0
        }

        let currentQuestion = triviaRound.getNextQuestion()
        XCTAssertNil(currentQuestion)
        XCTAssertEqual(triviaRound.numberCorrect, totalCorrect)
        XCTAssertEqual(triviaRound.percentCorrect, calculateCorrectPercentage(totalCorrect: totalCorrect, numberOfQuestions: validQuestions.count))
        XCTAssertEqual(triviaRound.getResults(), TriviaRound.Results(percentCorrect: triviaRound.percentCorrect, numberCorrect: triviaRound.numberCorrect, numberOfQuestions: validQuestions.count))
    }

    func testTriviaRoundIsNilWithNoQuestions() {
        XCTAssertNil(TriviaRound(questionData: []))
    }

}
