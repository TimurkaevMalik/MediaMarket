//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 13.06.2024.
//

import UIKit
import ProgressHUD

final class CartViewController: UIViewController {
    
    // MARK: - Public Properties
    
    let servicesAssembly: ServicesAssembly
    var nfts: [NftInCartModel] = []
    
    // MARK: - Private Properties
    
    private let bottomBackground = UIView()
    private let nftTableView = UITableView()
    private let paymentButton = UIButton()
    private let nftCountLable = UILabel()
    private let nftPriceLable = UILabel()
    private let cartIsEmptyLable = UILabel()
    private let cartNetworkService = CartNetworkService()
    
    // MARK: - Initializers
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadNfts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadNfts()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        if nfts.isEmpty {
            addCartIsEmptyLable()
        } else {
            addBottomBackground()
            addNftTableView()
            addPaymentButton()
            addNftCountLable()
            addNftPriceLable()
        }
    }
    
    private func reloadView() {
        bottomBackground.removeFromSuperview()
        nftTableView.removeFromSuperview()
        paymentButton.removeFromSuperview()
        nftCountLable.removeFromSuperview()
        nftPriceLable.removeFromSuperview()
        cartIsEmptyLable.removeFromSuperview()
        setupViews()
    }
    
    private func reloadNfts() {
    var nfts: [NftInCartModel] = []
        ProgressHUD.show()
        cartNetworkService.fetchOrder() { result in
            switch result {
            case .success(let order):
                var numberOfCicle = 0
                order.nfts.forEach({ id in
                    self.cartNetworkService.requestByNftId(id: id) { result in
                        switch result {
                        case .success(let nft):
                            let nftInCard = NftInCartModel(
                                name: nft.name,
                                rating: nft.rating,
                                price: "\(nft.price) ETH",
                                picture: nft.images[0])
                            nfts.append(nftInCard)
                            numberOfCicle += 1
                            if numberOfCicle == order.nfts.count {
                                DispatchQueue.main.async {
                                    self.nfts = nfts
                                    ProgressHUD.dismiss()
                                    self.reloadView()
                                }
                            }
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func addBottomBackground() {
        bottomBackground.backgroundColor = UIColor(named: "YPLightGray")
        bottomBackground.layer.masksToBounds = true
        bottomBackground.layer.cornerRadius = 12
        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBackground)
        NSLayoutConstraint.activate([
            bottomBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackground.heightAnchor.constraint(equalToConstant: 159)
        ])
    }
    
    private func addNftTableView() {
        nftTableView.delegate = self
        nftTableView.dataSource = self
        nftTableView.rowHeight = 140
        nftTableView.separatorStyle = .none
        nftTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftTableView)
        NSLayoutConstraint.activate([
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: bottomBackground.topAnchor)
        ])
    }
    
    private func addPaymentButton() {
        paymentButton.setTitle("К оплате", for: .normal)
        paymentButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        paymentButton.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        paymentButton.backgroundColor = UIColor(named: "YPBlack")
        paymentButton.layer.masksToBounds = true
        paymentButton.layer.cornerRadius = 16
        paymentButton.addTarget(self, action: #selector(paymentButtonTap), for: .touchUpInside)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBackground.addSubview(paymentButton)
        NSLayoutConstraint.activate([
            paymentButton.topAnchor.constraint(equalTo: bottomBackground.topAnchor, constant: 16),
            paymentButton.trailingAnchor.constraint(equalTo: bottomBackground.trailingAnchor, constant: -16),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func addNftCountLable() {
        nftCountLable.text = "3 NFT"
        nftCountLable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nftCountLable.textColor = UIColor(named: "YPBlack")
        nftCountLable.translatesAutoresizingMaskIntoConstraints = false
        bottomBackground.addSubview(nftCountLable)
        NSLayoutConstraint.activate([
            nftCountLable.leadingAnchor.constraint(equalTo: bottomBackground.leadingAnchor, constant: 16),
            nftCountLable.topAnchor.constraint(equalTo: bottomBackground.topAnchor, constant: 16)
        ])
    }
    
    private func addNftPriceLable() {
        nftPriceLable.text = "5,34 ETH"
        nftPriceLable.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nftPriceLable.textColor = UIColor(named: "YPGreen")
        nftPriceLable.translatesAutoresizingMaskIntoConstraints = false
        bottomBackground.addSubview(nftPriceLable)
        NSLayoutConstraint.activate([
            nftPriceLable.leadingAnchor.constraint(equalTo: bottomBackground.leadingAnchor, constant: 16),
            nftPriceLable.topAnchor.constraint(equalTo: nftCountLable.bottomAnchor, constant: 2)
        ])
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        if let tabBar = tabBarController?.tabBar {
            let tabBarBlurEffectView = UIVisualEffectView(effect: blurEffect)
            tabBarBlurEffectView.frame = tabBar.bounds
            tabBarBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            tabBar.addSubview(tabBarBlurEffectView)
        }
    }
    
    private func addCartIsEmptyLable() {
        cartIsEmptyLable.text = "Корзина пустая"
        cartIsEmptyLable.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        cartIsEmptyLable.textColor = UIColor(named: "YPBlack")
        cartIsEmptyLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cartIsEmptyLable)
        NSLayoutConstraint.activate([
            cartIsEmptyLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartIsEmptyLable.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Private Actions
    
    @objc private func paymentButtonTap() {
        print("Кнопка оплаты нажата")
    }
}
