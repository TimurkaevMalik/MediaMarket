//
//  PaymentMethodeCell.swift
//  MediaMarket
//
//  Created by Олег Спиридонов on 20.06.2024.
//

import Foundation
import UIKit
import Kingfisher

final class PaymentMethodeCell: UICollectionViewCell {

    // MARK: - Public Properties

    var paymentMethodModel: PaymentMethodModel?

    // MARK: - Private Properties

    private let backgroundCellView = UIView()
    private let nameLable = UILabel()
    private let abbreviationLable = UILabel()
    private let imageView = UIImageView()
    private let backgroundImageView = UIView()

    // MARK: - Public Methods

    func setupCell(paymentMethodModel: PaymentMethodModel) {
        self.paymentMethodModel = paymentMethodModel
        setupViews()
    }

    func selectCell() {
        backgroundCellView.layer.borderWidth = 1
    }

    func deselectCell() {
        backgroundCellView.layer.borderWidth = 0
    }

    // MARK: - Private Methods

    private func setupViews() {
        addBackground()
        addBackgroundImage()
        addImageView()
        addNameLable()
        addAbbreviationLable()
    }

    private func addBackground() {
        backgroundCellView.backgroundColor = UIColor(named: "YPLightGray")
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.layer.cornerRadius = 12
        backgroundCellView.layer.borderColor = UIColor(named: "YPBlack")?.cgColor
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundCellView)
        NSLayoutConstraint.activate([
            backgroundCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundCellView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    private func addBackgroundImage() {
        backgroundImageView.backgroundColor = UIColor(named: "YPBlack")
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.layer.cornerRadius = 6
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCellView.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor, constant: 12),
            backgroundImageView.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 5),
            backgroundImageView.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: -5),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func addImageView() {
        guard let paymentMethodModel else { return }
        guard let url = URL(string: paymentMethodModel.imageURL) else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 2.25),
            imageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 2.25),
            imageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -2.25),
            imageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -2.25)
        ])
    }

    private func addNameLable() {
        guard let paymentMethodModel else { return }
        nameLable.text = paymentMethodModel.name
        nameLable.textColor = UIColor(named: "YPBlack")
        nameLable.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        backgroundCellView.addSubview(nameLable)
        NSLayoutConstraint.activate([
            nameLable.leadingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: 4),
            nameLable.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 5)
        ])
    }

    private func addAbbreviationLable() {
        guard let paymentMethodModel else { return }
        abbreviationLable.text = paymentMethodModel.abbreviation
        abbreviationLable.textColor = UIColor(named: "YPGreen")
        abbreviationLable.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        abbreviationLable.translatesAutoresizingMaskIntoConstraints = false
        backgroundCellView.addSubview(abbreviationLable)
        NSLayoutConstraint.activate([
            abbreviationLable.leadingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: 4),
            abbreviationLable.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: -5)
        ])
    }
}
