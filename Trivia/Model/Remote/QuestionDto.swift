//
//  QuestionDto.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import Foundation

struct QuestionDto: Codable, Equatable {
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
