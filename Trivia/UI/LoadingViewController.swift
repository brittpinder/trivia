//
//  LoadingViewController.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-24.
//

import UIKit

class LoadingViewController: UIViewController {

    let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

//MARK: - UI Configuration
extension LoadingViewController {
    private func configureView() {
        view.backgroundColor = K.Colors.background

        view.addSubview(spinner)

        spinner.color = .white
        spinner.startAnimating()

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
