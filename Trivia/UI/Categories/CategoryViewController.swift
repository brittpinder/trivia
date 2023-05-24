//
//  CategoryViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-24.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func selectedCategory(id: Int)
}

class CategoryViewController: UIViewController {

    private let edgeInset: CGFloat = K.Spacing.marginMultiplier * 8
    private let spaceBetweenItems: CGFloat = 16
    private let numColumns = 2

    private var collectionView: UICollectionView!

    weak var delegate: CategoryViewControllerDelegate?

    private let categories: [CategoryDto]

    init(categories: [CategoryDto]) {
        self.categories = categories
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

//MARK: - UI Configuration
extension CategoryViewController {
    private func configureView() {
        view.backgroundColor = .white
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - UICollectionView
extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategoryId = categories[indexPath.row].id
        delegate?.selectedCategory(id: selectedCategoryId)
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            assertionFailure("Failed to cast UICollectionViewCell to CategoryCell!")
            return UICollectionViewCell()
        }

        let category = CategoryUtil.getCategory(for: categories[indexPath.row].name)
        cell.configure(with: category, index: indexPath.row)
        return cell
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insetWidth = 2 * edgeInset
        let widthBetweenCells = CGFloat(numColumns - 1) * spaceBetweenItems
        let cellWidth = (collectionView.frame.width - insetWidth - widthBetweenCells) / CGFloat(numColumns)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spaceBetweenItems
    }
}
