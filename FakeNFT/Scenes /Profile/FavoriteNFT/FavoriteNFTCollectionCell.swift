//
//  FavoriteNFTCollectionCell.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 28.06.2024.
//

import Foundation


import UIKit
import Kingfisher


final class FavoriteNFTCollectionCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    private lazy var viewsContainer = UIView()
    private lazy var nftImageView = UIImageView()
    private lazy var nftNameLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var likeButton = UIButton()
    
    private lazy var ratingImageView: RatingImageView = {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        return RatingImageView(frame: frame)
    }()
    
    var nft: NFTResult?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.cancelDownloadTask()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViewsContainer()
        configureNFTImageView()
        configureLikeButton()
        configureRatingImageView()
        configureNameAndAuthorLabels()
        configurePriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLikeButton() {
        delegate?.cellLikeButtonTapped(self)
    }
    
    private func configureViewsContainer(){
        viewsContainer.backgroundColor = .clear
        
        viewsContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewsContainer)
        
        NSLayoutConstraint.activate([
            viewsContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configureNFTImageView() {
        
        if let nftImageLink = nft?.images.first {
            nftImageView.kf.setImage(with: URL(string: nftImageLink), placeholder: UIImage(systemName: "photo"))
        }
        
        nftImageView.layer.masksToBounds = true
        nftImageView.layer.cornerRadius = 12
        
        viewsContainer.addSubview(nftImageView)
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height)
        ])
    }
    
    private func configureLikeButton(){
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor)
        ])
        
        likeButton.layer.masksToBounds = true
        likeButton.layer.cornerRadius = likeButton.frame.height / 2
    }
    
    private func configureRatingImageView() {
        ratingImageView.backgroundColor = .clear

        ratingImageView.updateRatingImagesBy(nft?.rating ?? 0)
        
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.addSubview(ratingImageView)
        
        NSLayoutConstraint.activate([
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            ratingImageView.centerYAnchor.constraint(equalTo: viewsContainer.centerYAnchor),
            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20)
        ])
    }
    
    private func configureNameAndAuthorLabels(){
        nftNameLabel.textColor = .ypBlack
        
        nftNameLabel.textAlignment = .left
        nftNameLabel.font = .bodyBold
        
        if let author = nft?.author, let nftName = nft?.name {
            nftNameLabel.text = nftName.cutString(at: " ")
        }
        
        nftNameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.addSubview(nftNameLabel)
        
        NSLayoutConstraint.activate([
            nftNameLabel.heightAnchor.constraint(equalToConstant: 22),
            nftNameLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4)
        ])
    }
    
    private func configurePriceLabel() {
        priceLabel.textColor = .ypBlack
        priceLabel.textAlignment = .left
        priceLabel.numberOfLines = 2
        priceLabel.font = .caption2
        
        if let price = nft?.price {
            let priceString = "\(price) ETH"
            let attributedString = NSMutableAttributedString(string: priceString)
            
            attributedString.setFont(.bodyBold, forText: "\(priceString)")
            priceLabel.attributedText = attributedString
        }
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            priceLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: ratingImageView.trailingAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor)
        ])
    }
    
    func setLikeImageForLikeButton() {
        likeButton.setImage(UIImage(named: "redHeart"), for: .normal)
    }
    
    func removeLikeImageForLikeButton() {
        likeButton.setImage(UIImage(named: "whiteHeart"), for: .normal)
    }
}
