//
//  QuestionTests.swift
//  TriviaTests
//
//  Created by Brittany Pinder on 2023-05-16.
//

import XCTest
@testable import Trivia

final class QuestionTests: XCTestCase {

    func testQuestionNotNil() throws {
        let question = Question(question: "Question", answers: ["Answer1", "Answer2"], correctIndex: 0)
        XCTAssertNotNil(question)
        XCTAssertEqual(question!.question, "Question")
        XCTAssertEqual(question!.answers, ["Answer1", "Answer2"])
        XCTAssertEqual(question!.correctIndex, 0)
    }

    func testQuestionWithEmptyQuestion() throws {
        XCTAssertNil(Question(question: "", answers: ["Answer1", "Answer2"], correctIndex: 1))
    }

    func testQuestionWithEmptyAnswer() throws {
        XCTAssertNil(Question(question: "Question", answers: ["Answer1", ""], correctIndex: 1))
    }

    func testQuestionWithNoAnswers() throws {
        XCTAssertNil(Question(question: "Question", answers: [], correctIndex: 0))
    }

    func testQuestionWithNegativeIndex() throws {
        XCTAssertNil(Question(question: "Question", answers: ["Answer1", "Answer2"], correctIndex: -1))
    }

    func testQuestionWithOutOfRangeIndex() throws {
        XCTAssertNil(Question(question: "Question", answers: ["Answer1", "Answer2"], correctIndex: 2))
    }

}
