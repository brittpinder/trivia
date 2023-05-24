//
//  StringUtil.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-05-24.
//

import Foundation

struct StringUtil {

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
