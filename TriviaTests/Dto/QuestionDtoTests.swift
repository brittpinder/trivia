//
//  QuestionDtoTests.swift
//  TriviaTests
//
//  Created by Brittany Pinder on 2023-05-16.
//

import XCTest
@testable import Trivia

final class QuestionDtoTests: XCTestCase {

    func testValidQuestionDto() throws {
        let json = """
        {
             "category": "Geography",
             "question": "What is the capital of Canada?",
             "correct_answer": "Ottawa",
             "incorrect_answers": [
                 "Toronto",
                 "Ontario",
                 "Vancouver"
             ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let questionDto = try decoder.decode(QuestionDto.self, from: data)

        XCTAssertEqual(questionDto.category, "Geography")
        XCTAssertEqual(questionDto.question, "What is the capital of Canada?")
        XCTAssertEqual(questionDto.correctAnswer, "Ottawa")
        XCTAssertEqual(questionDto.incorrectAnswers, ["Toronto", "Ontario", "Vancouver"])
    }

    func testQuestionDtoFailsWithoutCategory() {
        let json = """
        {
             "question": "What is the capital of Canada?",
             "correct_answer": "Ottawa",
             "incorrect_answers": [
                 "Toronto",
                 "Ontario",
                 "Vancouver"
             ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(QuestionDto.self, from: data))
    }

    func testQuestionDtoFailsWithoutQuestion() {
        let json = """
        {
             "category": "Geography",
             "correct_answer": "Ottawa",
             "incorrect_answers": [
                 "Toronto",
                 "Ontario",
                 "Vancouver"
             ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(QuestionDto.self, from: data))
    }

    func testQuestionDtoFailsWithMisspelledCorrectAnswer() {
        let json = """
        {
             "category": "Geography",
             "question": "What is the capital of Canada?",
             "correctAnswer": "Ottawa",
             "incorrect_answers": [
                 "Toronto",
                 "Ontario",
                 "Vancouver"
             ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(QuestionDto.self, from: data))
    }

    func testQuestionDtoFailsWithMisspelledIncorrectAnswers() {
        let json = """
        {
             "category": "Geography",
             "question": "What is the capital of Canada?",
             "correct_answer": "Ottawa",
             "incorrectanswers": [
                 "Toronto",
                 "Ontario",
                 "Vancouver"
             ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(QuestionDto.self, from: data))
    }

}
