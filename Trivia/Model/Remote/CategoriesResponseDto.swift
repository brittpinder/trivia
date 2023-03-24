//
//  CategoriesResponseDto.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-23.
//

import Foundation

struct CategoriesResponseDto: Codable {
    let triviaCategories: [CategoryDto]

    enum CodingKeys: String, CodingKey {
        case triviaCategories = "trivia_categories"
    }
}
