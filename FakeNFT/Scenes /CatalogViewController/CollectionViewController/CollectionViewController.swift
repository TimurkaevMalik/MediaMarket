import UIKit
import WebKit
import Kingfisher

final class CollectionViewController: UIViewController {

    // MARK: - Private Properties

    private let nftInfo: CollectionNftModel
    private var nfts: [Nft] = []
    private var orders: Order = Order(nfts: [])
    private let servicesAssembly: ServicesAssembly

    private lazy var coverCollectionImageView: UIImageView = {
        let coverCollectionImageView = UIImageView()
        coverCollectionImageView.translatesAutoresizingMaskIntoConstraints = false
        coverCollectionImageView.layer.cornerRadius = 12
        coverCollectionImageView.clipsToBounds = true
        coverCollectionImageView.contentMode = .scaleAspectFill
        return coverCollectionImageView
    }()

    private lazy var nameCollectionLabel: UILabel = {
        let nameCollectionLabel = UILabel()
        nameCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameCollectionLabel.font = .boldSystemFont(ofSize: 22)
        nameCollectionLabel.textColor = .black
        return nameCollectionLabel
    }()

    private lazy var authorCollectionLabel: UILabel = {
        let nameCollectionLabel = UILabel()
        nameCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameCollectionLabel.font = .systemFont(ofSize: 13)
        nameCollectionLabel.textColor = .black
        nameCollectionLabel.isUserInteractionEnabled = true
        nameCollectionLabel.text = NSLocalizedString("Collection.nameCollectionLabelText", comment: "")
        nameCollectionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLink)))
        return nameCollectionLabel
    }()

    private lazy var descriptionCollectionLabel: UILabel = {
        let descriptionCollectionLabel = UILabel()
        descriptionCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionCollectionLabel.font = .systemFont(ofSize: 13)
        descriptionCollectionLabel.textColor = .black
        descriptionCollectionLabel.numberOfLines = 0
        return descriptionCollectionLabel
    }()

    private var dataSource: UICollectionViewDiffableDataSource<Int, Nft>?
    private var nftCollectionView: UICollectionView?
    private var link: URL?

    // MARK: - Initializers

    init(servicesAssembly: ServicesAssembly, nftInfo: CollectionNftModel) {
        self.nftInfo = nftInfo
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupCollectionInfo()
        setupCoverCollectionImage()
        setupNameLabel()
        setupAuthorLabel()
        setupDescriptionLabel()
        loadNftItems()
    }

    // MARK: - Private Methods

    private func setupCollectionInfo() {
        coverCollectionImageView.kf.setImage(with: nftInfo.cover)
        nameCollectionLabel.text = nftInfo.name
        descriptionCollectionLabel.text = nftInfo.description
    }

    private func setupAuthorField() {

        let descriptionField = authorCollectionLabel.text ?? ""
        let author = nftInfo.author

        let fullText = descriptionField + author

        let attributedString = NSMutableAttributedString(string: fullText)

        if let range = fullText.range(of: author),
           let link = link {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.link, value: link, range: nsRange)
        }

        authorCollectionLabel.attributedText = attributedString
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
        nameCollectionLabel.topAnchor.constraint(
            equalTo: coverCollectionImageView.bottomAnchor,
            constant: 16
        ).isActive = true
        nameCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameCollectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        nameCollectionLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }

    private func setupAuthorLabel() {
        view.addSubview(authorCollectionLabel)
        authorCollectionLabel.topAnchor.constraint(
            equalTo: nameCollectionLabel.bottomAnchor,
            constant: 12
        ).isActive = true
        authorCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        authorCollectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        authorCollectionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    private func setupDescriptionLabel() {
        view.addSubview(descriptionCollectionLabel)
        descriptionCollectionLabel.topAnchor.constraint(equalTo: authorCollectionLabel.bottomAnchor).isActive = true
        descriptionCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionCollectionLabel.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -16
        ).isActive = true
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

        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.5)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)

        nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        guard let nftCollectionView = nftCollectionView else { return }

        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdent)
        nftCollectionView.backgroundColor = .systemBackground

        view.addSubview(nftCollectionView)

        nftCollectionView.topAnchor.constraint(equalTo: descriptionCollectionLabel.bottomAnchor).isActive = true
        nftCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func configureDataSource() {

        guard let nftCollectionView = nftCollectionView else { return }

        dataSource = UICollectionViewDiffableDataSource<Int, Nft>(
            collectionView: nftCollectionView
        ) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewCell.reuseIdent,
                for: indexPath
            ) as? CollectionViewCell else {
                fatalError("Cannot create new cell")
            }

            let nft = Nft(
                name: item.name,
                images: item.images,
                rating: item.rating,
                price: item.price,
                author: item.author,
                id: item.id
            )

            cell.setupNetworkClient(with: self.servicesAssembly)
            cell.configCell(with: nft)

            return cell
        }
    }

    private func applyInitialSnapshot() {
        guard let dataSource = dataSource else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Nft>()
        snapshot.appendSections([0])
        snapshot.appendItems(nfts, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func loadNftItems() {

        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()
            for nftId in self.nftInfo.nfts {
                group.enter()
                self.servicesAssembly.nftService.loadNft(id: nftId.uuidString.lowercased()) { result in
                    switch result {
                    case .success(let nft):
                        self.nfts.append(nft)
                    case .failure(let error):
                        print(error)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.setupNftCollectionView()
                self.link = self.nfts.first?.author
                self.setupAuthorField()
            }
        }
    }
}

// MARK: - WKNavigationDelegate

extension CollectionViewController: WKNavigationDelegate {

    @objc func didTapLink() {
        guard let link = link else { return }

        let webViewController = UIViewController()
        let webView = WKWebView(frame: webViewController.view.bounds)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: link))

        let backButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        backButton.tintColor = .black

        navigationItem.backBarButtonItem = backButton

        webViewController.view.addSubview(webView)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
