//
//  NFTCollectionController.swift
//  MediaMarket
//
//  Created by Malik Timurkaev on 25.06.2024.
//

import UIKit

final class NFTCollectionController: UIViewController {

    private weak var delegate: NFTCollectionControllerDelegate?

    private let warningLabel = UILabel()
    private let warningLabelContainer = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var topViewsContainer = UIView()
    private lazy var centralPlugLabel = UILabel()
    private lazy var closeButton = UIButton()
    private lazy var sortButton = UIButton()
    private lazy var nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var alertPresenter: AlertPresenter?
    private var nftFactory: NFTFactory?

    private var warningLabelTopConstraint: [NSLayoutConstraint] = []
    private var nftResult: [NFTResult] = []
    private var nftIdArray: [String]
    private var favoriteNFTsId: [String]
    private let nftCollectionCellIdentifier = "nftCollectionCellIdentifier"
    private let params = GeomitricParams(cellCount: 1, leftInset: 16, rightInset: 16, cellSpacing: 0)

    init(delegate: NFTCollectionControllerDelegate,
         nftIdArray: [String],
         favoriteNFTsId: [String]) {

        self.delegate = delegate
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
        configureLimitWarningLabel()

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
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    private func configureTitleLabel() {
        titleLabel.textColor = .ypBlack
        titleLabel.text = "Мои NFT"
        titleLabel.font = UIFont.bodyBold

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor)
        ])
    }

    private func configureCentralPlugLabel() {
        centralPlugLabel.textColor = .ypBlack
        centralPlugLabel.isHidden = true

        centralPlugLabel.text = "У вас ещё нет NFT"
        centralPlugLabel.textAlignment = .center
        centralPlugLabel.font = .bodyBold
        centralPlugLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centralPlugLabel)

        NSLayoutConstraint.activate([
            centralPlugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralPlugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
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

    private func configureLimitWarningLabel() {
        warningLabelContainer.backgroundColor = UIColor.ypWhite
        warningLabel.textColor = .ypBlue
        warningLabel.backgroundColor = .ypBlack?.withAlphaComponent(0.7)
        warningLabel.font = UIFont.systemFont(ofSize: 17)
        warningLabel.numberOfLines = 2
        warningLabel.textAlignment = .center

        warningLabel.layer.masksToBounds = true
        warningLabel.layer.cornerRadius = 10

        view.addSubview(warningLabel)
        view.addSubview(warningLabelContainer)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabelContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            warningLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            warningLabelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            warningLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        let constraint = warningLabel.topAnchor.constraint(equalTo: warningLabelContainer.topAnchor)

        warningLabelTopConstraint.append(constraint)

        warningLabelTopConstraint.first?.isActive = true
    }

    private func showWarningLabel(with text: String) {

        warningLabel.text = text

        DispatchQueue.main.async {

            if let constraint = self.warningLabelTopConstraint.first {

                UIView.animate(withDuration: 0.5) {
                    constraint.constant = -50
                    self.view.layoutIfNeeded()

                } completion: { _ in

                    UIView.animate(withDuration: 0.4, delay: 2) {
                        constraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
}

extension NFTCollectionController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        if nftResult.isEmpty {
            centralPlugLabel.isHidden = false
            sortButton.isHidden = true
            titleLabel.isHidden = true
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

    func didUpdateFavoriteNFT(_ favoriteNFTs: FavoriteNFTResult) {

        delegate?.didUpdateFavoriteNFT(favoriteNFTs.likes)

        if favoriteNFTs.likes.count > favoriteNFTsId.count {

            if let appendedNFT = favoriteNFTs.likes.first(where: { !favoriteNFTsId.contains($0)}),
               let cellSection = nftResult.firstIndex(where: { $0.id == appendedNFT }) {

                favoriteNFTsId = favoriteNFTs.likes

                nftCollectionView.performBatchUpdates {
                    nftCollectionView.reloadSections([cellSection])
                }
            }
        } else {

            if let removedNFT = favoriteNFTsId.first(where: { !favoriteNFTs.likes.contains($0) }),
               let cellSection = nftResult.firstIndex(where: { $0.id == removedNFT }) {

                favoriteNFTsId = favoriteNFTs.likes

                nftCollectionView.performBatchUpdates {
                    nftCollectionView.reloadSections([cellSection])
                }
            }
        }
    }

    func didFailToUpdateFavoriteNFT(with error: NetworkServiceError) {
        let errorString: String

        switch error {

        case .codeError(let value):
            errorString = value
        case .responseError(let value):
            errorString = "\(value)"
        case .invalidRequest:
            errorString = "Unknown error"
        }

        let warningText = "Ошбика: \(errorString)" + "\n" + "Не удалось обновить избранные"
        showWarningLabel(with: warningText)
    }

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

    private func fetchNextNFT() {

        UIBlockingProgressHUD.show()

        if nftResult.count < nftIdArray.count {
            let nextNFT = nftIdArray[nftResult.count]
            nftFactory?.loadNFT(id: nextNFT)
        } else {
            nftCollectionView.reloadData()
            UIBlockingProgressHUD.dismiss()
        }
    }

    private func changeFavoriteNFTRequest(nftIdArray: [String]) {
        nftFactory?.updateFavoriteNFTOnServer(nftIdArray)
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

extension NFTCollectionController: CollectionViewCellDelegate {
    func cellLikeButtonTapped(_ cell: UICollectionViewCell) {
        guard let indexPath = nftCollectionView.indexPath(for: cell) else {
            return
        }

        let likedNftId = nftResult[indexPath.section].id
        var newNFTArray: [String] = []

        if let nftId = favoriteNFTsId.first(where: { $0 == likedNftId }) {
            newNFTArray = favoriteNFTsId.filter({ $0 != nftId })
        } else {
            newNFTArray = favoriteNFTsId
            newNFTArray.append(likedNftId)
        }

        changeFavoriteNFTRequest(nftIdArray: newNFTArray)
    }
}
