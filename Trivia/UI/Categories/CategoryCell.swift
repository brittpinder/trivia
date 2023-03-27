//
//  CategoryCell.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-24.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    static let identifier = "CategoryCell"

    private let stackView = UIStackView()
    private var icon = UIImageView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
        configureStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: Category, index: Int) {
        label.text = category.displayName
        icon.image = UIImage(systemName: category.iconName, withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle))

        let colorIndex = index % K.Colors.categoryColors.count
        backgroundColor = K.Colors.categoryColors[colorIndex]
    }
}

//MARK: - UI Configuration
extension CategoryCell {
    private func configureView() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    private func configureStackView() {
        addSubview(stackView)

        stackView.addArrangedSubview(icon)
        stackView.addArrangedSubview(label)

        icon.tintColor = .white

        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    }
}
