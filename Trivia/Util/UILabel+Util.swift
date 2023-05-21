//
//  UILabel+Util.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-21.
//

import UIKit

extension UILabel {
    // A: What does this do exactly and why 4? 
    func removeVerticalPadding() {
        heightAnchor.constraint(equalToConstant: font.capHeight + 4).isActive = true
    }
}
