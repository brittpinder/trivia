//
//  NetworkManager.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import Foundation

struct QuestionData: Codable {
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

struct QuestionResults: Codable {
    let responseCode: Int
    let results: [QuestionData]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

enum NetworkError: String, Error {
    case invalidURL
    case serverError
    case decodingError
}

class NetworkManager {
    let baseURL = "https://opentdb.com/api.php?"

    func fetchQuestions(category: Int, amount: Int, completed: @escaping (Result<[QuestionData], NetworkError>) -> Void) {
        let endpoint = baseURL + "category=\(category)&amount=\(amount)&type=multiple"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completed(.failure(.serverError))
                return
            }

            do {
                let questions = try JSONDecoder().decode(QuestionResults.self, from: data)
                completed(.success(questions.results))
            } catch {
                completed(.failure(.decodingError))
            }
        }

        task.resume()
    }
}

