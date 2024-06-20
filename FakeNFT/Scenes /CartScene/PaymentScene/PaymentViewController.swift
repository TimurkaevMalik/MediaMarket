//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 20.06.2024.
//

import Foundation
import UIKit

final class PaymentViewController: UIViewController {
    
    // MARK: - Public Properties
    
    let paymentMethods: [PaymentMethodModel] = [
        PaymentMethodModel(name: "Рубль", abbreviation: "RUB", imageURL: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png"),
        PaymentMethodModel(name: "Рубль", abbreviation: "RUB", imageURL: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png"),
        PaymentMethodModel(name: "Рубль", abbreviation: "RUB", imageURL: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png"),
        PaymentMethodModel(name: "Рубль", abbreviation: "RUB", imageURL: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png")]
    
    // MARK: - Private Properties
    
    private let paymentMethodeColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 7 
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let backgroundView = UIView()
    private let backgroundTextLable = UILabel()
    private let userAgreementButton = UIButton()
    private let paymentButton = UIButton()
    
    // MARK: - Initializers
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaymentMethodeColletionView()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundTopCorners(view: backgroundView, radius: 12)
    }
    
    // MARK: - Public Methods
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        setupNavBar()
        addBackgroundView()
        addPaymentMethodeColletionView()
        addBbackroundTextLable()
        addUserAgreementButton()
        addPaymentButton()
    }
    
    private func setupNavBar() {
        title = "Выберите способ оплаты"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") as Any,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)
        ]
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func addPaymentMethodeColletionView() {
        paymentMethodeColletionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paymentMethodeColletionView)
        NSLayoutConstraint.activate([
            paymentMethodeColletionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            paymentMethodeColletionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            paymentMethodeColletionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            paymentMethodeColletionView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor)
        ])
    }
    
    private func setupPaymentMethodeColletionView() {
        paymentMethodeColletionView.delegate = self
        paymentMethodeColletionView.dataSource = self
        paymentMethodeColletionView.register(PaymentMethodeCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func addBackgroundView() {
        backgroundView.backgroundColor = UIColor(named: "YPLightGray")
        backgroundView.layer.masksToBounds = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 186)
        ])
    }
    
    func roundTopCorners(view: UIView, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    private func addBbackroundTextLable() {
        backgroundTextLable.text = "Совершая покупку, вы соглашаетесь с условиями"
        backgroundTextLable.textColor = UIColor(named: "YPBlack")
        backgroundTextLable.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        backgroundTextLable.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(backgroundTextLable)
        NSLayoutConstraint.activate([
            backgroundTextLable.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            backgroundTextLable.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16)
        ])
    }
    
    private func addUserAgreementButton() {
        userAgreementButton.setTitle("Пользовательского соглашения", for: .normal)
        userAgreementButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        userAgreementButton.contentHorizontalAlignment = .left
        userAgreementButton.setTitleColor(UIColor(named: "YPBlue"), for: .normal)
        userAgreementButton.addTarget(self, action: #selector(userAgreementButtonTapped), for: .touchUpInside)
        userAgreementButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(userAgreementButton)
        NSLayoutConstraint.activate([
            userAgreementButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            userAgreementButton.topAnchor.constraint(equalTo: backgroundTextLable.bottomAnchor),
            userAgreementButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            userAgreementButton.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    private func addPaymentButton() {
        paymentButton.setTitle("Оплатить", for: .normal)
        paymentButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        paymentButton.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        paymentButton.backgroundColor = UIColor(named: "YPBlack")
        paymentButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
        paymentButton.layer.masksToBounds = true
        paymentButton.layer.cornerRadius = 12
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(paymentButton)
        NSLayoutConstraint.activate([
            paymentButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            paymentButton.topAnchor.constraint(equalTo: userAgreementButton.bottomAnchor, constant: 16),
            paymentButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    // MARK: - Public Actions
    // MARK: - Private Actions
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func userAgreementButtonTapped() {
        print("Пользовательское соглашение")
    }
    
    @objc private func paymentButtonTapped() {
        print("Оплата")
    }
}
