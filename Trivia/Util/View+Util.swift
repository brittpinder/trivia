//
//  View+Util.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-04-21.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
