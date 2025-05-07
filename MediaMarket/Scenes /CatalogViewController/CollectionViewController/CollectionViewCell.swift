import UIKit
import Kingfisher

final class CollectionViewCell: UICollectionViewCell {

    // MARK: - Public Properties

    static let reuseIdent = "CollectionViewCell"

    // MARK: - Private Properties

    internal let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    private var id = ""
    private var orders: Set<String> = []
    private var likes: Set<String> = []
    private var isFavorite = false
    private var isCard = false

    private var servicesAssembly: ServicesAssembly?

    private lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.isUserInteractionEnabled = true
        return coverImageView
    }()

    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(named: "whiteHeart"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButon), for: .touchUpInside)
        return favoriteButton
    }()

    private lazy var ratingStackView: RatingView = {
        let ratingStackView = RatingView()
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        return ratingStackView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 17)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 2
        return nameLabel
    }()

    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 10)
        priceLabel.textColor = .black
        return priceLabel
    }()

    private lazy var cardButton: UIButton = {
        let cardButton = UIButton()
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        cardButton.setImage(UIImage(named: "emptyCart"), for: .normal)
        cardButton.addTarget(self, action: #selector(didTapCardButon), for: .touchUpInside)
        return cardButton
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setupCoverImage()
        setupFavoriteButton()
        setupRatingStackView()
        setupNameLabel()
        setupPriceLabel()
        setupCardButton()
        setupActivityIndicator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configCell(with nft: Nft) {
        id = nft.id
        loadOrders()
        loadLikes()
        nameLabel.text = nft.name
        coverImageView.kf.setImage(with: nft.images[0])
        ratingStackView.setRating(nft.rating)
        priceLabel.text = "\(nft.price) ETH"
    }

    func setupNetworkClient(with client: ServicesAssembly) {
        servicesAssembly = client
    }

    // MARK: - Private Methods

    private func setupCoverImage() {
        contentView.addSubview(coverImageView)
        coverImageView.widthAnchor.constraint(equalToConstant: 108).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    private func setupFavoriteButton() {
        coverImageView.addSubview(favoriteButton)
        favoriteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: coverImageView.topAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor).isActive = true
    }

    private func setupRatingStackView() {
        contentView.addSubview(ratingStackView)
        ratingStackView.widthAnchor.constraint(equalToConstant: 68).isActive = true
        ratingStackView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        ratingStackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8).isActive = true
        ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    private func setupPriceLabel() {
        contentView.addSubview(priceLabel)
        priceLabel.widthAnchor.constraint(equalToConstant: 500).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 11.93).isActive = true
        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    private func setupCardButton() {
        contentView.addSubview(cardButton)
        cardButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cardButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cardButton.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 24).isActive = true
        cardButton.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor).isActive = true
    }

    private func loadOrders() {
        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()

            group.enter()
            self.servicesAssembly?.orderService.loadOrder { result in
                switch result {
                case .success(let orders):
                    self.orders = Set(orders.nfts)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }

                group.leave()
            }

            group.notify(queue: .main) {
                self.isCard = self.orders.contains(self.id)
                self.cardButton.setImage(UIImage(named: self.isCard ? "crossCart" : "emptyCart"), for: .normal)
            }
        }
    }

    private func loadLikes() {
        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()

            group.enter()
            self.servicesAssembly?.profileService.loadProfile { result in
                switch result {
                case .success(let profile):
                    self.likes = Set(profile.likes)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }

                group.leave()
            }

            group.notify(queue: .main) {
                self.isFavorite = self.likes.contains(self.id)
                self.favoriteButton.setImage(UIImage(named: self.isFavorite ? "redHeart" : "whiteHeart"), for: .normal)
            }
        }
    }

    @objc
    private func didTapFavoriteButon() {
        activityIndicator.startAnimating()

        loadLikes()

        if isFavorite {
            likes.remove(id)
        } else {
            likes.insert(id)
        }

        servicesAssembly?.profileService.setProfile(body: Array(likes)) { result in
            switch result {
            case .success:
                self.isFavorite = !self.isFavorite
                self.favoriteButton.setImage(UIImage(named: self.isFavorite ? "redHeart" : "whiteHeart"), for: .normal)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        activityIndicator.stopAnimating()
    }

    @objc
    private func didTapCardButon() {
        activityIndicator.startAnimating()

        loadOrders()

        if isCard {
            orders.remove(id)
        } else {
            orders.insert(id)
        }

        servicesAssembly?.orderService.updateOrder(body: Array(orders)) { result in
            switch result {
            case .success:
                self.isCard = !self.isCard
                self.cardButton.setImage(UIImage(named: self.isCard ? "crossCart" : "emptyCart"), for: .normal)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        activityIndicator.stopAnimating()
    }
}

// MARK: - LoadingView

extension CollectionViewCell: LoadingView {
    private func setupActivityIndicator() {
        contentView.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: contentView)
    }
}
