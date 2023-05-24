//
//  StringUtil.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-05-24.
//

import Foundation

struct StringUtil {

    static let documentReadingOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
    ]

    static func getDecodedString(htmlEncodedString: String) -> String? {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(data: data, options: documentReadingOptions, documentAttributes: nil) else {
            return nil
        }

        return attributedString.string
    }
}
