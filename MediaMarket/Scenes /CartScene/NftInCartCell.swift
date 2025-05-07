//
//  NftInCartCell.swift
//  MediaMarket
//
//  Created by Олег Спиридонов on 15.06.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol NftInCartCellDelegate: AnyObject {
    func deleteNftFromCart(nftModel: NftInCartModel)
}

final class NftInCartCell: UITableViewCell {

    // MARK: - Public Properties

    weak var delegate: NftInCartCellDelegate?

    // MARK: - Private Properties

    private let nftImageView = UIImageView()
    private let nftNameLable = UILabel()
    private let ratingView = StarRatingView()
    private let nftPriceLable = UILabel()
    private let deleteNftButton = UIButton()
    private var nftModel: NftInCartModel?

    // MARK: - Public Methods

    func setupCell(nftModel: NftInCartModel) {
        addNftImage(imageStr: nftModel.picture)
        addNftName(name: nftModel.name)
        addRatingView(rating: nftModel.rating)
        addNftPriceLable(price: nftModel.price)
        addDeleteNftButton()
        self.nftModel = nftModel
    }

    // MARK: - Private Methods

    private func addNftImage(imageStr: String) {
        guard let url = URL(string: imageStr) else { return }
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        nftImageView.layer.masksToBounds = true
        nftImageView.layer.cornerRadius = 12
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nftImageView)
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)
        ])
    }

    private func addNftName(name: String) {
        nftNameLable.text = name
        nftNameLable.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nftNameLable.textColor = UIColor(named: "YPBlack")
        nftNameLable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nftNameLable)
        NSLayoutConstraint.activate([
            nftNameLable.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftNameLable.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8)
        ])
    }

    private func addRatingView(rating: Int) {
        ratingView.rating = rating
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingView)
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            ratingView.topAnchor.constraint(equalTo: nftNameLable.bottomAnchor, constant: 4),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            ratingView.widthAnchor.constraint(equalToConstant: 68)
        ])
    }

    private func addNftPriceLable(price: Double) {
        let title = UILabel()
        title.text = "Цена"
        title.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        title.textColor = UIColor(named: "YPBlack")
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            title.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 12)
        ])
        nftPriceLable.text = "\(price) ETH"
        nftPriceLable.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nftPriceLable.textColor = UIColor(named: "YPBlack")
        nftPriceLable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nftPriceLable)
        NSLayoutConstraint.activate([
            nftPriceLable.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftPriceLable.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2)
        ])

    }

    private func addDeleteNftButton() {
        deleteNftButton.setImage(UIImage(named: "DeleteNftInCart"), for: .normal)
        deleteNftButton.addTarget(self, action: #selector(deleteNftButtonTap), for: .touchUpInside)
        deleteNftButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteNftButton)
        NSLayoutConstraint.activate([
            deleteNftButton.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            deleteNftButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteNftButton.widthAnchor.constraint(equalToConstant: 40),
            deleteNftButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Private Actions

    @objc private func deleteNftButtonTap() {
        guard let nftModel else { return }
        delegate?.deleteNftFromCart(nftModel: nftModel)
    }
}
