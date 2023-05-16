//
//  QuestionUtil.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import Foundation

struct QuestionUtil {
    static func getQuestions(from questionData: [QuestionDto]) -> [Question] {
        var questions = [Question]()

        for data in questionData {
            guard let questionText = getDecodedString(htmlEncodedString: data.question) else {
                assertionFailure("Failed to decode htmlEncoded string: \(data.question)")
                continue
            }

            guard let correctAnswer = getDecodedString(htmlEncodedString: data.correctAnswer) else {
                assertionFailure("Failed to decode htmlEncoded string: \(data.correctAnswer)")
                continue
            }
            var answers = [correctAnswer]

            var failedToDecodeAnswer = false
            for answer in data.incorrectAnswers {
                guard let decodedAnswer = getDecodedString(htmlEncodedString: answer) else {
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

    static func getDecodedString(htmlEncodedString: String) -> String? {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        return attributedString.string
    }
}
