//
//  FavoriteNFTController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 28.06.2024.
//

import UIKit


final class FavoriteNFTController: UIViewController {
    
    weak var delegate: NFTCollectionControllerDelegate?
    
    private lazy var titleLabel = UILabel()
    private lazy var topViewsContainer = UIView()
    
    private var alertPresenter: AlertPresenter?
    private var nftFactory: NFTFactory?
    
    private var nftResult: [NFTResult] = []
    private var favoriteNFTsId: [String]
    
    
    init(delegate: NFTCollectionControllerDelegate,
         favoriteNFTsId: [String]) {
        
        self.delegate = delegate
        self.favoriteNFTsId = favoriteNFTsId
        super.init(nibName: nil, bundle: nil)
        
        alertPresenter = AlertPresenter(viewController: self)
        nftFactory = NFTFactory(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        configureTopViewsContainer()
        configureTitleLabel()
    }
    
    private func configureTopViewsContainer() {
        topViewsContainer.backgroundColor = .ypWhite
        topViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topViewsContainer)
        
        NSLayoutConstraint.activate([
            topViewsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewsContainer.heightAnchor.constraint(equalToConstant: 42),
            topViewsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    private func configureTitleLabel(){
        titleLabel.textColor = .ypBlack
        titleLabel.text = "Избранные NFT"
        titleLabel.font = UIFont.bodyBold
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor)
        ])
    }
}

extension FavoriteNFTController: NFTFactoryDelegate {
    func didRecieveNFT(_ nft: NFTResult) {}
    func didUpdateFavoriteNFT(_ favoriteNFTs: FavoriteNFTResult) {}
    func didFailToLoadNFT(with error: NetworkServiceError) {}
    func didFailToUpdateFavoriteNFT(with error: NetworkServiceError) {}
}
