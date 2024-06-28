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
    private lazy var closeButton = UIButton()
    private lazy var topViewsContainer = UIView()
    private lazy var centralPlugLabel = UILabel()
    private lazy var nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var alertPresenter: AlertPresenter?
    private var nftFactory: NFTFactory?
    
    private var nftResult: [NFTResult] = []
    private var favoriteNFTsId: [String]
    private let nftCollectionCellIdentifier = "nftCollectionCellIdentifier"
    private let params = GeomitricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 7)
    
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
        
        configureCentralPlugLabel()
        configureTopViewsContainer()
        configureTitleLabel()
        configureCloseButton()
        configureNFTCollectionView()
    }
    
    @objc func closeControllerButtonTapped() {
        dismiss(animated: true)
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
    
    private func configureCloseButton() {
        let image = UIImage(systemName: "chevron.backward")
        closeButton.tintColor = .ypBlack
        
        closeButton.setImage(image, for: .normal)
        closeButton.addTarget(self, action: #selector(closeControllerButtonTapped), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: topViewsContainer.leadingAnchor, constant: 9)
        ])
    }
    
    private func configureCentralPlugLabel(){
        centralPlugLabel.textColor = .ypBlack
        
        centralPlugLabel.text = "У Вас ещё нет избранных NFT"
        centralPlugLabel.textAlignment = .center
        centralPlugLabel.font = .bodyBold
        centralPlugLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centralPlugLabel)
        
        NSLayoutConstraint.activate([
            centralPlugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralPlugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            centralPlugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centralPlugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ])
    }
    
    private func configureNFTCollectionView() {
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        nftCollectionView.backgroundColor = .clear
        
        nftCollectionView.register(FavoriteNFTController.self, forCellWithReuseIdentifier: nftCollectionCellIdentifier)
        
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftCollectionView)
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: topViewsContainer.bottomAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension FavoriteNFTController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if nftResult.isEmpty {
            centralPlugLabel.isHidden = false
        } else {
            centralPlugLabel.isHidden = true
            titleLabel.isHidden = false
        }
        
        return nftResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nftCollectionCellIdentifier, for: indexPath) as? FavoriteNFTCollectionCell else {
            return UICollectionViewCell()
        }
        
        if favoriteNFTsId.contains(nftResult[indexPath.section].id) {
            cell.setLikeImageForLikeButton()
        } else {
            cell.removeLikeImageForLikeButton()
        }
        
        cell.delegate = self
        cell.nft = nftResult[indexPath.section]
        cell.awakeFromNib()
        
        return cell
    }
}

extension FavoriteNFTController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availibleSpacing = collectionView.frame.width - params.paddingWidth
        let cellWidth = availibleSpacing / params.cellCount
        
        return CGSize(width: cellWidth, height: cellWidth / 2.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

extension FavoriteNFTController: NFTFactoryDelegate {
    func didRecieveNFT(_ nft: NFTResult) {}
    func didUpdateFavoriteNFT(_ favoriteNFTs: FavoriteNFTResult) {}
    func didFailToLoadNFT(with error: NetworkServiceError) {}
    func didFailToUpdateFavoriteNFT(with error: NetworkServiceError) {}
}

extension FavoriteNFTController: CollectionViewCellDelegate {
    func cellLikeButtonTapped(_ cell: UICollectionViewCell) {}
}
