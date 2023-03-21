//
//  UILabel+Util.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import UIKit

extension UILabel {
    func removeVerticalPadding() {
        heightAnchor.constraint(equalToConstant: font.capHeight + 4).isActive = true
    }
}
