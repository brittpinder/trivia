//
//  UIStackView+Util.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-04-27.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
