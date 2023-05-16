//
//  CategoryDtoTests.swift
//  TriviaTests
//
//  Created by Brittany Pinder on 2023-05-16.
//

import XCTest
@testable import Trivia

final class CategoryDtoTests: XCTestCase {

    func testValidCategoryDto() throws {
        let json = """
        {
             "id": 9,
             "name": "Science"
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let categoryDto = try decoder.decode(CategoryDto.self, from: data)

        XCTAssertEqual(categoryDto.id, 9)
        XCTAssertEqual(categoryDto.name, "Science")
    }

    func testCategoryDtoFailsWithoutId() {
        let json = """
        {
             "name": "Science"
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(CategoryDto.self, from: data))
    }

    func testCategoryDtoFailsWithoutName() {
        let json = """
        {
             "id": 9
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(CategoryDto.self, from: data))
    }

    func testCategoryDtoFailsWithInvalidIdType() {
        let json = """
        {
             "id": "9",
             "name": "Science"
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(CategoryDto.self, from: data))
    }
}
