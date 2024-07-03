//
//  FavoriteNFTController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 28.06.2024.
//

import UIKit

final class FavoriteNFTController: UIViewController {

    weak var delegate: NFTCollectionControllerDelegate?

    private let warningLabel = UILabel()
    private let warningLabelContainer = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var closeButton = UIButton()
    private lazy var topViewsContainer = UIView()
    private lazy var centralPlugLabel = UILabel()
    private lazy var nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var alertPresenter: AlertPresenter?
    private var nftFactory: NFTFactory?

    private var warningLabelTopConstraint: [NSLayoutConstraint] = []
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
        configureLimitWarningLabel()

        if !favoriteNFTsId.isEmpty {
            fetchNextNFT()
        }
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
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    private func configureTitleLabel() {
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

    private func configureCentralPlugLabel() {
        centralPlugLabel.textColor = .ypBlack

        centralPlugLabel.text = "У Вас ещё нет избранных NFT"
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

    private func configureNFTCollectionView() {
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        nftCollectionView.backgroundColor = .clear

        nftCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        nftCollectionView.register(FavoriteNFTCollectionCell.self, forCellWithReuseIdentifier: nftCollectionCellIdentifier)

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

extension FavoriteNFTController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if nftResult.isEmpty {
            centralPlugLabel.isHidden = false
            titleLabel.isHidden = true
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

        cell.setLikeImageForLikeButton()

        cell.delegate = self
        cell.nft = nftResult[indexPath.row]
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
}

extension FavoriteNFTController: NFTFactoryDelegate {

    func didUpdateFavoriteNFT(_ favoriteNFTs: FavoriteNFTResult) {

        delegate?.didUpdateFavoriteNFT(favoriteNFTs.likes)

        if let removedNFT = favoriteNFTsId.first(where: { !favoriteNFTs.likes.contains($0) }),
           let cellRow = nftResult.firstIndex(where: { $0.id == removedNFT }) {

            favoriteNFTsId = favoriteNFTs.likes
            nftResult.remove(at: cellRow)

            nftCollectionView.performBatchUpdates {
                nftCollectionView.deleteItems(at: [IndexPath(item: cellRow, section: 0)])
            }
        } else {
            let warningText = "NFT удален из избранного" + "\n" + "Не удалось обновить экран"
            showWarningLabel(with: warningText)
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

        let warningText = "Ошбика: \(errorString)" + "\n" + "Не удалось удалить из избранных"
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

        if nftResult.count < favoriteNFTsId.count {
            let nextNFT = favoriteNFTsId[nftResult.count]
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

extension FavoriteNFTController: FetchNFTAlertDelegate {
    func tryToReloadNFT() {
        fetchNextNFT()
    }

    func loadRestOfNFT() {
        let lostNFTIndex = nftResult.count == 0 ? 0 : nftResult.count - 1
        favoriteNFTsId.remove(at: lostNFTIndex)
        fetchNextNFT()
    }

    func closeActionTapped() {
        centralPlugLabel.text = "Не удалось получить NFT"
    }
}

extension FavoriteNFTController: CollectionViewCellDelegate {

    func cellLikeButtonTapped(_ cell: UICollectionViewCell) {
        guard let indexPath = nftCollectionView.indexPath(for: cell) else { return }

        let likedNftId = nftResult[indexPath.row].id
        var newNFTArray: [String] = []

        if let nftId = favoriteNFTsId.first(where: { $0 == likedNftId }) {
            newNFTArray = favoriteNFTsId.filter({ $0 != nftId })
        } else {
            let warningText = "Ошбика: Unknown error" + "\n" + "Не удалось удалить из избранных"
            showWarningLabel(with: warningText)
            return
        }

        changeFavoriteNFTRequest(nftIdArray: newNFTArray)
    }
}
