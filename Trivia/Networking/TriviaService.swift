//
//  NetworkManager.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import Foundation

class TriviaService {

    enum NetworkError: String, Error {
        case invalidURL
        case serverError
        case decodingError
    }

    let baseURL = "https://opentdb.com/api.php?"

    func fetchQuestions(category: Int, amount: Int, completed: @escaping (Result<[QuestionDto], NetworkError>) -> Void) {
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
                let questions = try JSONDecoder().decode(QuestionsResponseDto.self, from: data)
                completed(.success(questions.results))
            } catch {
                completed(.failure(.decodingError))
            }
        }

        task.resume()
    }
}

