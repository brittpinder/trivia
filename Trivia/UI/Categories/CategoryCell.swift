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

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowColor = UIColor.black.cgColor

        addSubview(stackView)
        stackView.addArrangedSubviews(icon, label)

        configureStackView()
    }

    private func configureStackView() {
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
