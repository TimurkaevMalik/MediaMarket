//
//  SuccessfulPaymentViewController.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 20.06.2024.
//

import Foundation
import UIKit

final class SuccessfulPaymentViewController: UIViewController {
    // MARK: - Public Properties
    // MARK: - Private Properties
    
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let backButton = UIButton()
    
    // MARK: - Initializers
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Public Methods
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        addImageView()
        addTextLabel()
        addBackButton()
    }
    
    private func addImageView() {
        imageView.image = UIImage(named: "catInCart")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 278)
        ])
    }
    
    private func addTextLabel() {
        textLabel.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        textLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textLabel.textColor = UIColor(named: "YPBlack")
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 2
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }
    
    private func addBackButton() {
        backButton.setTitle("Вернутся в каталог", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        backButton.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        backButton.backgroundColor = UIColor(named: "YPBlack")
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 16
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Public Actions
    // MARK: - Private Actions
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
}
