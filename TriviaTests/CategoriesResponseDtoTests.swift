//
//  CategoriesResponseDtoTests.swift
//  TriviaTests
//
//  Created by Brittany Pinder on 2023-05-16.
//

import XCTest
@testable import Trivia

final class CategoriesResponseDtoTests: XCTestCase {

    func testValidCategoriesResponseDto() throws {
        let json = """
        {
            "trivia_categories": [
                {
                    "id": 9,
                    "name": "Science"
                },
                {
                    "id": 10,
                    "name": "Books"
                },
                {
                    "id": 11,
                    "name": "Geography"
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let categoriesResponseDto = try decoder.decode(CategoriesResponseDto.self, from: data)

        XCTAssertEqual(categoriesResponseDto.triviaCategories.count, 3)
        XCTAssertEqual(categoriesResponseDto.triviaCategories[0], CategoryDto(id: 9, name: "Science"))
        XCTAssertEqual(categoriesResponseDto.triviaCategories[1], CategoryDto(id: 10, name: "Books"))
        XCTAssertEqual(categoriesResponseDto.triviaCategories[2], CategoryDto(id: 11, name: "Geography"))
    }

    func testValidCategoriesResponseDtoFailsWithMisspelledKey() throws {
        let json = """
        {
            "triviaCategories": [
                {
                    "id": 9,
                    "name": "Science"
                },
                {
                    "id": 10,
                    "name": "Books"
                },
                {
                    "id": 11,
                    "name": "Geography"
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        XCTAssertThrowsError(try decoder.decode(CategoriesResponseDto.self, from: data))
    }

}
