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

    private let edgeInset: CGFloat = 20
    private let spaceBetweenItems: CGFloat = 15
    private let numColumns = 2

    private var collectionView: UICollectionView!

    weak var delegate: CategoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureCollectionView()
    }

    func reloadData() {
        collectionView?.reloadData()
    }
}

//MARK: - UI Configuration
extension CategoryViewController {
    private func configureView() {
        view.backgroundColor = .white
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.backgroundColor = .white

        view.addSubview(collectionView)

        collectionView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - UICollectionView
extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedCategoryId = TriviaService.shared.categories[indexPath.row].id
        delegate?.selectedCategory(id: selectedCategoryId)
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TriviaService.shared.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            assertionFailure("Failed to cast UICollectionViewCell to CategoryCell!")
            return UICollectionViewCell()
        }

        let category = CategoryUtil.getCategory(for: TriviaService.shared.categories[indexPath.row].name)
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
