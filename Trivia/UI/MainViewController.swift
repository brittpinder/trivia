//
//  ViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class MainViewController: UIViewController {

    private let loadingViewController = LoadingViewController()
    private let networkErrorViewController = NetworkErrorViewController()
    private var categoryViewController: CategoryViewController?
    private var questionViewController: QuestionViewController?
    private var resultsViewController: ResultsViewController?

    private var currentViewController: UIViewController?

    private var triviaService = TriviaService()
    private var triviaRound: TriviaRound?

    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
            self.hideLoadingViewController(animated: false)
        }))
        return alert
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchCategories()
    }
}

//MARK: - UI Configuration
extension MainViewController {
    private func configureView() {
        view.backgroundColor = .white
        networkErrorViewController.delegate = self
    }
}

//MARK: - Networking
extension MainViewController {
    private func fetchCategories() {
        triviaService.fetchCategories { [unowned self] (error) in
            DispatchQueue.main.async {
                if let error {
                    print(error.rawValue)
                    self.showViewController(animated: false, viewController: self.networkErrorViewController)
                } else {
                    self.categoryViewController = CategoryViewController(categories: self.triviaService.categories)
                    self.categoryViewController!.delegate = self
                    self.showViewController(animated: false, viewController: self.categoryViewController!)
                }
            }
        }
    }

    private func fetchQuestions(category: Int) {
        triviaService.fetchQuestions(category: category, amount: K.Settings.numQuestions) { [unowned self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    if let round = TriviaRound(questionData: questions) {
                        self.triviaRound = round
                        self.questionViewController = QuestionViewController(triviaRound: round)
                        self.questionViewController!.delegate = self
                        self.showViewController(animated: true, viewController: self.questionViewController!)
                        self.hideLoadingViewController(animated: true)
                    } else {
                        self.displayError(title: "Error", message: "Failed to retrieve trivia questions. Please try again.")
                    }
                case .failure:
                    self.displayError(title: "Network Error", message: "There was a problem retrieving trivia questions. Please check your internet connection and try again.")
                }
            }
        }
    }

    private func displayError(title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message
        present(errorAlert, animated: true, completion: nil)
    }
}

//MARK: - Child View Controllers
extension MainViewController {
    private func showLoadingViewController(animated: Bool, onTransitionComplete: ((Bool) -> Void)?) {
        add(loadingViewController)

        if animated {
            loadingViewController.view.alpha = 0
            UIView.animate(withDuration: K.Transition.duration,
                           animations: { self.loadingViewController.view.alpha = 1 },
                           completion: onTransitionComplete)
        } else {
            loadingViewController.view.alpha = 1
        }
    }

    private func hideLoadingViewController(animated: Bool) {
        if animated {
            UIView.animate(withDuration: K.Transition.duration,
                           animations: { self.loadingViewController.view.alpha = 0 },
                           completion: { [unowned self] finished in self.loadingViewController.remove() })
        } else {
            self.loadingViewController.remove()
        }
    }

    private func showViewController(animated: Bool, viewController: UIViewController) {
        if let currentViewController {
            currentViewController.remove()
        }

        add(viewController)
        currentViewController = viewController

        if animated {
            viewController.view.alpha = 0
            UIView.animate(withDuration: K.Transition.duration,
                           animations: { viewController.view.alpha = 1 },
                           completion: nil)
        } else {
            viewController.view.alpha = 1
        }
    }
}

//MARK: - NetworkErrorViewControllerDelegate
extension MainViewController: NetworkErrorViewControllerDelegate {
    func retryFetchingCategories() {
        fetchCategories()
    }
}

//MARK: - CategoryViewControllerDelegate
extension MainViewController: CategoryViewControllerDelegate {
    func selectedCategory(id: Int) {
        showLoadingViewController(animated: true, onTransitionComplete: { [unowned self] finished in
            self.fetchQuestions(category: id)
        })
    }
}

//MARK: - QuestionViewControllerDelegate
extension MainViewController: QuestionViewControllerDelegate {
    func didExitRound() {
        triviaRound = nil
        guard let categoryViewController else {
            assertionFailure("CategoryViewController should not be nil!")
            return
        }
        showViewController(animated: false, viewController: categoryViewController)
    }

    func didFinishRound() {
        guard let triviaRound else {
            assertionFailure("triviaRound should not be nil!")
            return
        }
        resultsViewController = ResultsViewController(results: triviaRound.getResults())
        resultsViewController!.delegate = self
        showViewController(animated: false, viewController: resultsViewController!)
    }
}

//MARK: - ResultsViewControllerDelegate
extension MainViewController: ResultsViewControllerDelegate {
    func playAgainPressed() {
        guard let categoryViewController else {
            assertionFailure("CategoryViewController should not be nil!")
            return
        }
        showViewController(animated: false, viewController: categoryViewController)
    }
}
