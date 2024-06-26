//
//  NFTCollectionController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 25.06.2024.
//

import UIKit


final class NFTCollectionController: UIViewController {
    
    private lazy var titleLabel = UILabel()
    private lazy var topViewsContainer = UIView()
    private lazy var centralPlugLabel = UILabel()
    private lazy var closeButton = UIButton()
    private lazy var sortButton = UIButton()
    private lazy var nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var alertPresenter: AlertPresenter?
    private var nftFactory: NFTFactory?
    
    private var nftResult: [NFTResult] = []
    private var nftIdArray: [String]
    private var favoriteNFTsId: [String]
    private let nftCollectionCellIdentifier = "nftCollectionCellIdentifier"
    private let params = GeomitricParams(cellCount: 1, leftInset: 16, rightInset: 16, cellSpacing: 0)
    
    
    init(nftIdArray: [String], favoriteNFTsId: [String]){
        self.nftIdArray = nftIdArray
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
        configureSortButton()
        configureNFTCollectionView()
        
        if !nftIdArray.isEmpty {
            fetchNextNFT()
        }
    }
    
    @objc func closeControllerButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func sortButtonTapped() {
        alertPresenter?.sortionAlert(delegate: self)
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
        titleLabel.isHidden = true
        titleLabel.text = "Мои NFT"
        titleLabel.font = UIFont.bodyBold
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor)
        ])
    }
    
    private func configureCentralPlugLabel(){
        centralPlugLabel.textColor = .ypBlack
        centralPlugLabel.isHidden = true
        
        centralPlugLabel.text = "У вас ещё нет NFT"
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
    
    private func configureSortButton() {
        let image = UIImage(named: "sortButtonImage")
        sortButton.tintColor = .ypBlack
        sortButton.isHidden = true
        
        sortButton.setImage(image, for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        
        NSLayoutConstraint.activate([
            sortButton.widthAnchor.constraint(equalToConstant: 24),
            sortButton.heightAnchor.constraint(equalToConstant: 24),
            sortButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: topViewsContainer.trailingAnchor, constant: -9)
        ])
    }
    
    private func configureNFTCollectionView() {
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        nftCollectionView.backgroundColor = .clear
        
        nftCollectionView.register(NFTCollectionCell.self, forCellWithReuseIdentifier: nftCollectionCellIdentifier)
        
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

extension NFTCollectionController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if nftResult.isEmpty {
            centralPlugLabel.isHidden = false
        } else {
            centralPlugLabel.isHidden = true
            titleLabel.isHidden = false
            sortButton.isHidden = false
        }
        
        return nftResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nftCollectionCellIdentifier, for: indexPath) as? NFTCollectionCell else {
            return UICollectionViewCell()
        }
    
        cell.nft = nftResult[indexPath.section]
        cell.awakeFromNib()
        
        return cell
    }
}

extension NFTCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availibleSpacing = collectionView.frame.width - params.paddingWidth
        let cellWidth = availibleSpacing / params.cellCount
        
        return CGSize(width: cellWidth, height: cellWidth / 3.18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}


extension NFTCollectionController: SortAlertDelegate {
    func sortByPrice() {
        nftResult.sort(by: { $0.price < $1.price })
        
        nftCollectionView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            
            nftCollectionView.reloadItems(at: indesPaths)
        }
    }
    
    func sortByRate() {
        nftResult.sort(by: { $0.rating > $1.rating })
        
        nftCollectionView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            
            nftCollectionView.reloadItems(at: indesPaths)
        }
    }
    
    func sortByName() {
        nftResult.sort(by: { $0.name < $1.name })
        
        nftCollectionView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            
            nftCollectionView.reloadItems(at: indesPaths)
        }
    }
}

extension NFTCollectionController: NFTFactoryDelegate {
    func didRecieveNFT(_ nft: NFTResult) {
        nftResult.append(nft)
        fetchNextNFT()
    }
    
    func didFailToLoadNFT(with error: NetworkServiceError) {
        
        UIBlockingProgressHUD.dismiss()
        nftCollectionView.reloadData()
        
        let errorString: String
        
        switch error {
            
        case .codeError(let value):
            errorString = value
        case .responseError(let value):
            errorString = "\(value)"
        case .invalidRequest:
            errorString = "Unknown error"
        }
        
        alertPresenter?.fetchNFTAlert(title: "Ошибка: \(errorString)", delegate: self)
    }
    
    func fetchNextNFT() {
        
        UIBlockingProgressHUD.show()
        
        if nftResult.count < nftIdArray.count {
            let nextNFT = nftIdArray[nftResult.count]
            nftFactory?.loadNFT(id: nextNFT)
        } else {
            nftCollectionView.reloadData()
            UIBlockingProgressHUD.dismiss()
        }
    }
}

extension NFTCollectionController: FetchNFTAlertDelegate {
    func tryToReloadNFT() {
        fetchNextNFT()
    }
    
    func loadRestOfNFT() {
        let lostNFTIndex = nftResult.count == 0 ? 0 : nftResult.count - 1
        nftIdArray.remove(at: lostNFTIndex)
        fetchNextNFT()
    }
    
    func closeActionTapped() {
        centralPlugLabel.text = "Не удалось получить NFT"
    }
}
