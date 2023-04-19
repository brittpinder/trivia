//
//  ViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-20.
//

import UIKit

class MainViewController: UIViewController {

    private let loadingViewController = LoadingViewController()
    private let categoryViewController: CategoryViewController
    private var questionViewController: QuestionViewController?
    private var resultsViewController: ResultsViewController?

    private var currentViewController: UIViewController?

    private var triviaService = TriviaService()
    private var triviaSession: TriviaSession?

    init() {
        categoryViewController = CategoryViewController(triviaService: triviaService)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        categoryViewController.delegate = self
    }
}

//MARK: - Networking
extension MainViewController {
    private func fetchCategories() {
        triviaService.fetchCategories { [unowned self] (error) in
            DispatchQueue.main.async {
                if let error {
                    print(error.rawValue)
                } else {
                    self.categoryViewController.reloadData()
                    self.showViewController(animated: false, viewController: self.categoryViewController)
                    self.hideLoadingViewController()
                }
            }
        }
    }

    private func fetchQuestions(category: Int) {
        triviaService.fetchQuestions(category: category, amount: 5) { [unowned self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    if let session = TriviaSession(questionData: questions) {
                        self.triviaSession = session
                        self.questionViewController = QuestionViewController(triviaSession: session)
                        self.questionViewController!.delegate = self
                        self.showViewController(animated: true, viewController: self.questionViewController!)
                        self.hideLoadingViewController()
                    } else {
                        // TODO: Handle case where failed to create Trivia Session (perhaps due to corrupt data)
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
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

    private func hideLoadingViewController() {
        UIView.animate(withDuration: K.Transition.duration,
                       animations: { self.loadingViewController.view.alpha = 0 },
                       completion: { [unowned self] finished in self.loadingViewController.remove() })
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
    func lastQuestionWasAnswered() {
        guard let triviaSession else {
            assertionFailure("triviaSession should not be nil!")
            return
        }
        resultsViewController = ResultsViewController(triviaSession: triviaSession)
        resultsViewController!.delegate = self
        showViewController(animated: false, viewController: resultsViewController!)
    }
}

//MARK: - ResultsViewControllerDelegate
extension MainViewController: ResultsViewControllerDelegate {
    func playAgainPressed() {
        showViewController(animated: false, viewController: categoryViewController)
    }
}
