//
//  ExitButton.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-04-27.
//

import UIKit

class ExitButton: UIButton {

    private let iconSize: CGFloat = 40

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - UI Configuration
extension ExitButton {
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .white
        setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: iconSize, weight: .thin), forImageIn: .normal)
    }
}
