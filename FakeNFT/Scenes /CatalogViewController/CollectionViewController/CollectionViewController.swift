//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Artem Krasnov on 22.06.2024.
//

import UIKit
import WebKit

final class CollectionViewController: UIViewController {

    // MARK: - Public Properties

    lazy var coverCollectionImageView: UIImageView = {
        let coverCollectionImageView = UIImageView()
        coverCollectionImageView.translatesAutoresizingMaskIntoConstraints = false
        coverCollectionImageView.layer.cornerRadius = 12
        coverCollectionImageView.clipsToBounds = true
        coverCollectionImageView.contentMode = .scaleAspectFill
        return coverCollectionImageView
    }()

    lazy var nameCollectionLabel: UILabel = {
        let nameCollectionLabel = UILabel()
        nameCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameCollectionLabel.font = .boldSystemFont(ofSize: 22)
        nameCollectionLabel.textColor = .black
        return nameCollectionLabel
    }()

    lazy var authorCollectionLabel: UILabel = {
        let nameCollectionLabel = UILabel()
        nameCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameCollectionLabel.font = .systemFont(ofSize: 13)
        nameCollectionLabel.textColor = .black
        nameCollectionLabel.isUserInteractionEnabled = true
        nameCollectionLabel.text = "Автор коллекции: "
        nameCollectionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLink)))
        return nameCollectionLabel
    }()

    lazy var descriptionCollectionLabel: UILabel = {
        let descriptionCollectionLabel = UILabel()
        descriptionCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionCollectionLabel.font = .systemFont(ofSize: 13)
        descriptionCollectionLabel.textColor = .black
        descriptionCollectionLabel.numberOfLines = 0
        return descriptionCollectionLabel
    }()

    // MARK: - Private Properties

    private var dataSource: UICollectionViewDiffableDataSource<Int, NftItem>?
    private var nftCollectionView: UICollectionView?
    private var link: String?

    // MARK: - Initializers

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        tempSetupMock()
        setupCoverCollectionImage()
        setupNameLabel()
        setupAuthorLabel()
        setupDescriptionLabel()
        setupNftCollectionView()
    }

    // MARK: - Public Methods

    // MARK: - Private Methods

    private func tempSetupMock() {
        coverCollectionImageView.image = UIImage(named: "White")
        nameCollectionLabel.text = "Peach"

        link = "https://www.ya.ru"
        let descriptionField = authorCollectionLabel.text ?? ""
        let author = "Kek Lolov"
        let fullText = descriptionField + author

        let attributedString = NSMutableAttributedString(string: fullText)

        if let range = fullText.range(of: author),
           let link = link {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.link, value: link, range: nsRange)
        }

        authorCollectionLabel.attributedText = attributedString

        descriptionCollectionLabel.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."

    }

    private func setupCoverCollectionImage() {
        view.addSubview(coverCollectionImageView)
        coverCollectionImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        coverCollectionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        coverCollectionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        coverCollectionImageView.heightAnchor.constraint(equalToConstant: 310).isActive = true
    }

    private func setupNameLabel() {
        view.addSubview(nameCollectionLabel)
        nameCollectionLabel.topAnchor.constraint(equalTo: coverCollectionImageView.bottomAnchor, constant: 16).isActive = true
        nameCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameCollectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        nameCollectionLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }

    private func setupAuthorLabel() {
        view.addSubview(authorCollectionLabel)
        authorCollectionLabel.topAnchor.constraint(equalTo: nameCollectionLabel.bottomAnchor, constant: 12).isActive = true
        authorCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        authorCollectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        authorCollectionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    private func setupDescriptionLabel() {
        view.addSubview(descriptionCollectionLabel)
        descriptionCollectionLabel.topAnchor.constraint(equalTo: authorCollectionLabel.bottomAnchor).isActive = true
        descriptionCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionCollectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        descriptionCollectionLabel.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }

    private func setupNftCollectionView() {
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension CollectionViewController {

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 108, height: 192)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 9, bottom: 8, right: 9)

        nftCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)

        guard let nftCollectionView = nftCollectionView else { return }

        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdent)
        nftCollectionView.backgroundColor = .systemBackground

        view.addSubview(nftCollectionView)

        nftCollectionView.topAnchor.constraint(equalTo: descriptionCollectionLabel.bottomAnchor).isActive = true
        nftCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func configureDataSource() {

        guard let nftCollectionView = nftCollectionView else { return }

        dataSource = UICollectionViewDiffableDataSource<Int, NftItem>(
            collectionView: nftCollectionView
        ) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewCell.reuseIdent,
                for: indexPath
            ) as? CollectionViewCell else {
                fatalError("Cannot create new cell")
            }

            cell.nameLabel.text = item.name
            cell.coverImageView.image = UIImage(named: "MockCell")
            cell.ratingStackView.setRating(item.rating)
            cell.priceLabel.text = "\(item.price) ETH"

            return cell
        }
    }

    private func applyInitialSnapshot() {
        guard let dataSource = dataSource else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Int, NftItem>()
        snapshot.appendSections([0])
        let items = loadNftItems()
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func loadNftItems() -> [NftItem] {

        let item1 = NftItem(id: UUID(), name: "NFT 1", rating: 4, price: 99.99, images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!], isFavorite: true)
        let item2 = NftItem(id: UUID(), name: "NFT 2", rating: 5, price: 149.99, images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!], isFavorite: false)
        let item3 = NftItem(id: UUID(), name: "NFT 3", rating: 3, price: 79.99, images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Dominique/1.png")!], isFavorite: true)

        let item4 = NftItem(id: UUID(), name: "NFT 4", rating: 4, price: 99.99, images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!], isFavorite: true)
        let item5 = NftItem(id: UUID(), name: "NFT 5", rating: 5, price: 149.99, images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!], isFavorite: false)
        let item6 = NftItem(id: UUID(), name: "NFT 6", rating: 3, price: 79.99, images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Dominique/1.png")!], isFavorite: true)

        return [item1, item2, item3, item4, item5, item6]
    }
}

// MARK: - WKNavigationDelegate

extension CollectionViewController: WKNavigationDelegate {

    @objc func didTapLink() {
        guard let link = link,
              let url = URL(string: link) else { return }

        let webViewController = UIViewController()
        let webView = WKWebView(frame: webViewController.view.bounds)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))

        let backButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        backButton.tintColor = .black

        navigationItem.backBarButtonItem = backButton

        webViewController.view.addSubview(webView)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
