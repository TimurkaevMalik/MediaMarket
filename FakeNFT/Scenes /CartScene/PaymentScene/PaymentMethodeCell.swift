//
//  PaymentMethodeCell.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 20.06.2024.
//

import Foundation
import UIKit
import Kingfisher

final class PaymentMethodeCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    // MARK: - Private Properties
    
    private var paymentMethodModel: PaymentMethodModel?
    private let backgroundCellView = UIView()
    private let nameLable = UILabel()
    private let abbreviationLable = UILabel()
    private let imageView = UIImageView()
    
    // MARK: - Initializers
    // MARK: - Lifecycle
    // MARK: - Public Methods
    
    func setupCell(paymentMethodModel: PaymentMethodModel) {
        self.paymentMethodModel = paymentMethodModel
        setupViews()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        addBackground()
        addImageView()
    }
    
    private func addBackground() {
        backgroundCellView.backgroundColor = UIColor(named: "YPLightGray")
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.layer.cornerRadius = 12
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundCellView)
        NSLayoutConstraint.activate([
            backgroundCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundCellView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    private func addImageView() {
        guard let paymentMethodModel else { return }
        guard let url = URL(string: paymentMethodModel.imageURL) else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCellView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor, constant: 12),
            imageView.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalToConstant: backgroundCellView.frame.height - 10)
        ])
    }
    // MARK: - Public Actions
    // MARK: - Private Actions
}
