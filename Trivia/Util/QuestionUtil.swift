//
//  QuestionUtil.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import Foundation

struct QuestionUtil {
    static func parseQuestions(from questionDtos: [QuestionDto]) -> [Question] {
        var questions = [Question]()

        for questionDto in questionDtos {
            guard let questionText = StringUtil.getDecodedString(htmlEncodedString: questionDto.question) else {
                assertionFailure("Failed to decode htmlEncoded string: \(questionDto.question)")
                continue
            }

            guard let correctAnswer = StringUtil.getDecodedString(htmlEncodedString: questionDto.correctAnswer) else {
                assertionFailure("Failed to decode htmlEncoded string: \(questionDto.correctAnswer)")
                continue
            }
            var answers = [correctAnswer]

            var failedToDecodeAnswer = false
            for answer in questionDto.incorrectAnswers {
                guard let decodedAnswer = StringUtil.getDecodedString(htmlEncodedString: answer) else {
                    assertionFailure("Failed to decode htmlEncoded string: \(answer)")
                    failedToDecodeAnswer = true
                    break
                }
                answers.append(decodedAnswer)
            }
            if failedToDecodeAnswer {
                continue
            }

            answers.shuffle()
            guard let correctIndex = answers.firstIndex(of: correctAnswer) else {
                assertionFailure("Error finding correct index!")
                continue
            }

            if let question = Question(question: questionText, answers: answers, correctIndex: correctIndex) {
                questions.append(question)
            } else {
                assertionFailure("Failed to create Question!")
            }
        }
        return questions
    }
}
