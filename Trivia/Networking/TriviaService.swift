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

    let categoryURL = "https://opentdb.com/api_category.php"
    let questionURL = "https://opentdb.com/api.php?"

    var categories = [String: Int]()

    func getCategoryId(name: String) -> Int? {
        return categories[name] ?? nil
    }

    func fetchCategories(completed: @escaping (NetworkError?) -> Void) {
        guard let url = URL(string: categoryURL) else {
            completed(.invalidURL)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completed(.serverError)
                return
            }

            do {
                let response = try JSONDecoder().decode(CategoriesResponseDto.self, from: data)
                for category in response.triviaCategories {
                    self.categories[category.name] = category.id
                }
                completed(nil)
            } catch {
                completed(.decodingError)
            }
        }

        task.resume()
    }

    func fetchQuestions(category: Int, amount: Int, completed: @escaping (Result<[QuestionDto], NetworkError>) -> Void) {
        let endpoint = questionURL + "category=\(category)&amount=\(amount)&type=multiple"

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

