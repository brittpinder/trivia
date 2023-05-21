//
//  QuestionUtil.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import Foundation

struct QuestionUtil {
    // A: "data" is not recommended in variable names since it doesn't provide extra value
    // Suggestions: questionDtos, questionsFromApi, questionsToConvert
    // A: getQuestions sounds like a getter, but it actually does more
    // Suggestions: convert, read, parse, process
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
            // A: can we skip this and do answer checking based on string comparison, or are we concerned about performance?
            guard let correctIndex = answers.firstIndex(of: correctAnswer) else {
                assertionFailure("Error finding correct index!")
                continue
            }

            // A: it looks like we do validation in the code above but also in the constructor
            // If we need to add more validation in the future, it might be unclear where it should be done
            if let question = Question(question: questionText, answers: answers, correctIndex: correctIndex) {
                questions.append(question)
            } else {
                assertionFailure("Failed to create Question!")
            }
        }
        return questions
    }

    // A: Since this has nothing to do with questions, it could be moved to a StringUtil or similar
    static func getDecodedString(htmlEncodedString: String) -> String? {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        // A: could this be a constant to prevent multiple array allocations
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
