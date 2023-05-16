//
//  QuestionsResponseDtoTests.swift
//  TriviaTests
//
//  Created by Brittany Pinder on 2023-05-16.
//

import XCTest

@testable import Trivia

final class QuestionsResponseDtoTests: XCTestCase {

    func testValidQuestionsResponseDto() throws {
        let json = """
        {
            "response_code": 0,
            "results": [
                {
                    "category": "General",
                    "question": "Area 51 is located in which US state?",
                    "correct_answer": "Nevada",
                    "incorrect_answers": [
                        "Arizona",
                        "New Mexico",
                        "Utah"
                    ]
                },
                {
                    "category": "Computers",
                    "question": "In web design, what does CSS stand for?",
                    "correct_answer": "Cascading Style Sheet",
                    "incorrect_answers": [
                        "Counter Strike: Source",
                        "Corrective Style Sheet",
                        "Computer Style Sheet"
                    ]
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let questionsResponseDto = try decoder.decode(QuestionsResponseDto.self, from: data)

        XCTAssertEqual(questionsResponseDto.responseCode, 0)
        XCTAssertEqual(questionsResponseDto.results.count, 2)
        XCTAssertEqual(questionsResponseDto.results[0], QuestionDto(category: "General", question: "Area 51 is located in which US state?", correctAnswer: "Nevada", incorrectAnswers: ["Arizona", "New Mexico", "Utah"]))
        XCTAssertEqual(questionsResponseDto.results[1], QuestionDto(category: "Computers", question: "In web design, what does CSS stand for?", correctAnswer: "Cascading Style Sheet", incorrectAnswers: ["Counter Strike: Source", "Corrective Style Sheet", "Computer Style Sheet"]))

    }

    func testQuestionsResponseDtoFailsWithoutResponseCode() {
        let json = """
        {
            "results": [
                {
                    "category": "General",
                    "question": "Area 51 is located in which US state?",
                    "correct_answer": "Nevada",
                    "incorrect_answers": [
                        "Arizona",
                        "New Mexico",
                        "Utah"
                    ]
                },
                {
                    "category": "Computers",
                    "question": "In web design, what does CSS stand for?",
                    "correct_answer": "Cascading Style Sheet",
                    "incorrect_answers": [
                        "Counter Strike: Source",
                        "Corrective Style Sheet",
                        "Computer Style Sheet"
                    ]
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(QuestionsResponseDto.self, from: data))
    }

    func testQuestionsResponseDtoFailsWithoutResults() {
        let json = """
        {
            "response_code": 0,
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(QuestionsResponseDto.self, from: data))
    }

}
