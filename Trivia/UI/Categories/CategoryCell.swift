//
//  CategoryCell.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-24.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    static let identifier = "CategoryCell"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
        configureLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: String) {
        self.label.text = category
    }
}

//MARK: - UI Configuration
extension CategoryCell {
    private func configureView() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    private func configureLabel() {
        addSubview(label)

        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    }
}
