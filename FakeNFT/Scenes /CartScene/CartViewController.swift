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
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let cartNetworkService = CartNetworkService()

    // MARK: - Private Properties

    private let bottomBackground = UIView()
    private let nftTableView = UITableView()
    private let paymentButton = UIButton()
    private let nftCountLable = UILabel()
    private let nftPriceLable = UILabel()
    private let cartIsEmptyLable = UILabel()
    private let sortButton = UIButton()
    private var sortMethod: Int?

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
        setupViews()
        reloadNfts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadNfts()
    }

    // MARK: - Public Methods

    func turnOnBlurEffect() {
        blurEffectView.isHidden = false
    }

    func reloadNfts() {
         var nfts: [NftInCartModel] = []
         ProgressHUD.show()
         cartNetworkService.fetchOrder { [weak self] result in
             switch result {
             case .success(let order):
                 var numberOfCicle = 0
                 if order.nfts.isEmpty {
                     DispatchQueue.main.async {
                         self?.nfts = nfts
                         ProgressHUD.dismiss()
                         self?.reloadView()
                     }
                 } else {
                     order.nfts.forEach({ id in
                         self?.cartNetworkService.requestByNftId(id: id) { [weak self] result in
                             switch result {
                             case .success(let nft):
                                 let nftInCard = NftInCartModel(
                                    id: nft.id,
                                    name: nft.name,
                                    rating: nft.rating,
                                    price: nft.price,
                                    picture: nft.images[0])
                                 nfts.append(nftInCard)
                                 numberOfCicle += 1
                                 if numberOfCicle == order.nfts.count {
                                     DispatchQueue.main.async {
                                         self?.nfts = nfts
                                         ProgressHUD.dismiss()
                                         self?.sortNft()
                                         self?.reloadView()
                                     }
                                 }
                             case .failure(let error):
                                 print("Error: \(error.localizedDescription)")
                             }
                         }
                     })
                 }
             case .failure(let error):
                 print("Error: \(error.localizedDescription)")
             }
         }
     }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        addCartIsEmptyLable()
        addBottomBackground()
        addNftTableView()
        addPaymentButton()
        addNftCountLable()
        addNftPriceLable()
        addBlurEffectToWindow()
        addSortButton()
    }

    private func reloadView() {
        if nfts.isEmpty {
            cartIsEmptyLable.isHidden = false
            bottomBackground.isHidden = true
            nftTableView.isHidden = true
            paymentButton.isHidden = true
            nftCountLable.isHidden = true
            nftPriceLable.isHidden = true
            sortButton.isHidden = true
        } else {
            cartIsEmptyLable.isHidden = true
            bottomBackground.isHidden = false
            nftTableView.isHidden = false
            nftTableView.reloadData()
            paymentButton.isHidden = false
            nftCountLable.isHidden = false
            nftCountLable.text = "\(nfts.count) NFT"
            nftPriceLable.isHidden = false
            nftPriceLable.text = "\(returnFullPrice()) ETH"
            sortButton.isHidden = false
        }
    }

    private func addBottomBackground() {
        bottomBackground.backgroundColor = UIColor(named: "YPLightGray")
        bottomBackground.layer.masksToBounds = true
        bottomBackground.layer.cornerRadius = 12
        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        bottomBackground.isHidden = true
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
        nftTableView.allowsSelection = false
        nftTableView.translatesAutoresizingMaskIntoConstraints = false
        nftTableView.isHidden = true
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
        paymentButton.isHidden = true
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
        nftCountLable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nftCountLable.textColor = UIColor(named: "YPBlack")
        nftCountLable.isHidden = true
        nftCountLable.translatesAutoresizingMaskIntoConstraints = false
        bottomBackground.addSubview(nftCountLable)
        NSLayoutConstraint.activate([
            nftCountLable.leadingAnchor.constraint(equalTo: bottomBackground.leadingAnchor, constant: 16),
            nftCountLable.topAnchor.constraint(equalTo: bottomBackground.topAnchor, constant: 16)
        ])
    }

    private func addNftPriceLable() {
        nftPriceLable.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nftPriceLable.textColor = UIColor(named: "YPGreen")
        nftPriceLable.translatesAutoresizingMaskIntoConstraints = false
        nftPriceLable.isHidden = true
        bottomBackground.addSubview(nftPriceLable)
        NSLayoutConstraint.activate([
            nftPriceLable.leadingAnchor.constraint(equalTo: bottomBackground.leadingAnchor, constant: 16),
            nftPriceLable.topAnchor.constraint(equalTo: nftCountLable.bottomAnchor, constant: 2),
            nftPriceLable.trailingAnchor.constraint(equalTo: paymentButton.leadingAnchor, constant: 24)
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
        cartIsEmptyLable.isHidden = true
        view.addSubview(cartIsEmptyLable)
        NSLayoutConstraint.activate([
            cartIsEmptyLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartIsEmptyLable.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func addBlurEffectToWindow() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            blurEffectView.frame = window.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.isHidden = true
            window.addSubview(blurEffectView)
            UIView.animate(withDuration: 1.0) {
                self.blurEffectView.effect = UIBlurEffect(style: .light)
            }
        }
    }

    private func returnFullPrice() -> String {
        var price: Double = 0
        nfts.forEach { nft in
            price += nft.price
        }
        let formattedNumber = String(format: "%.2f", price)
        return formattedNumber
    }

    private func addSortButton() {
        sortButton.setImage(UIImage(named: "SortButton"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        sortButton.isHidden = true
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func showSortAlert() {
            let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
            let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
                self?.sortMethod = 1
                self?.sortNft()
                self?.nftTableView.reloadData()
            }
            let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
                self?.sortMethod = 2
                self?.sortNft()
                self?.nftTableView.reloadData()
            }
            let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
                self?.sortMethod = 3
                self?.sortNft()
                self?.nftTableView.reloadData()
            }
            alert.addAction(sortByPriceAction)
            alert.addAction(sortByRatingAction)
            alert.addAction(sortByNameAction)
            let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }

    private func sortNft() {
        if self.sortMethod != nil {
            switch sortMethod {
            case 1:
                nfts = nfts.sortedByPrice()
            case 2:
                nfts = nfts.sortedByRating()
            case 3:
                nfts = nfts.sortedByName()
            default:
                break
            }
        }
    }

    // MARK: - Private Actions

    @objc private func paymentButtonTap() {
        let paymentVC = PaymentViewController()
        paymentVC.cartViewController = self
        let navController = UINavigationController(rootViewController: paymentVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }

    @objc private func sortButtonTapped() {
        showSortAlert()
    }
}
