//
//  CollectionViewCell.swift
//  FakeNFT
//
//  Created by Artem Krasnov on 22.06.2024.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

    // MARK: - Public Properties

    static let reuseIdent: String = "CollectionViewCell"

    lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.isUserInteractionEnabled = true
        return coverImageView
    }()

    lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(named: "whiteHeart"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButon), for: .touchUpInside)
        return favoriteButton
    }()

    lazy var ratingStackView: RatingView = {
        let ratingStackView = RatingView()
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        return ratingStackView
    }()

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 17)
        nameLabel.textColor = .black
        return nameLabel
    }()

    lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 10)
        priceLabel.textColor = .black
        return priceLabel
    }()

    lazy var cardButton: UIButton = {
        let cardButton = UIButton()
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        cardButton.setImage(UIImage(named: "emptyCart"), for: .normal)
        cardButton.addTarget(self, action: #selector(didTapCardButon), for: .touchUpInside)
        return cardButton
    }()

    // MARK: - Private Properties

    private var isFavorite = false
    private var isCard = false

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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        nameLabel.widthAnchor.constraint(equalToConstant: 68).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
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
        cardButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    @objc
    private func didTapFavoriteButon() {
        favoriteButton.setImage(UIImage(named: isFavorite ? "redHeart" : "whiteHeart"), for: .normal)
        isFavorite = !isFavorite
    }

    @objc
    private func didTapCardButon() {
        cardButton.setImage(UIImage(named: isCard ? "crossCart" : "emptyCart"), for: .normal)
        isCard = !isCard
    }
}
