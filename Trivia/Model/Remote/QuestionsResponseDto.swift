//
//  QuestionsResponseDto.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import Foundation

struct QuestionsResponseDto: Codable {
    let responseCode: Int
    let results: [QuestionDto]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}
