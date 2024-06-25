//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 25.06.2024.
//

import Foundation


import UIKit
import Kingfisher


final class NFTCollectionCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    private lazy var viewsContainer = UIView()
    private lazy var nftImageView = UIImageView()
    private lazy var nftNameLabel = UILabel()
    private lazy var authorLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var likeButton = UIButton()
    
    private lazy var ratingImageView: UIImageView = {
        
        let frame = CGRect(x: 0, y: 0, width: 108, height: 108)
        let ratingNumber = nft?.rating ?? 0
        
        return RatingImageView(frame: frame, ratingNumber: ratingNumber)
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
        
        likeButton.setImage(UIImage(named: "whiteHeart"), for: .normal)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        nftImageView.addSubview(likeButton)
        
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
        authorLabel.textColor = .ypBlack
        
        nftNameLabel.textAlignment = .left
        nftNameLabel.font = .bodyBold
        authorLabel.font = .caption2
        
        if let author = nft?.author, let nftName = nft?.name {
            nftNameLabel.text = nftName.cutString(at: " ")
            authorLabel.text = "От \(author)"
        }
        
        nftNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.addSubview(nftNameLabel)
        viewsContainer.addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            nftNameLabel.heightAnchor.constraint(equalToConstant: 22),
            nftNameLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),
            
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            authorLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: ratingImageView.trailingAnchor),
            authorLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4)
        ])
    }
    
    private func configurePriceLabel() {
        priceLabel.textColor = .ypBlack
        priceLabel.textAlignment = .left
        priceLabel.numberOfLines = 2
        priceLabel.font = .caption2
        
        if let price = nft?.price {
            let priceString = "\(price) ETH"
            let attributedString = NSMutableAttributedString(string: "Цена" + "\n" + "\(priceString)")
            
            attributedString.setFont(.bodyBold, forText: "\(priceString)")
            priceLabel.attributedText = attributedString
        }
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: viewsContainer.topAnchor, constant: 33),
            priceLabel.bottomAnchor.constraint(equalTo: viewsContainer.bottomAnchor, constant: -33),
            priceLabel.trailingAnchor.constraint(equalTo: viewsContainer.trailingAnchor),
            priceLabel.leadingAnchor.constraint(lessThanOrEqualTo: nftImageView.trailingAnchor, constant: 137)
        ])
    }
    
    private func setLikeButtonImage() {
        ////TODO прописать логику изменения лайка по информации профиля
    }
    
    private func highLightButton(){
        
        UIView.animate(withDuration: 0.2) {
            
            self.likeButton.backgroundColor = .red
            
        } completion: { isCompleted in
            if isCompleted {
                resetButtonColor()
            }
        }
        
        func resetButtonColor(){
            UIView.animate(withDuration: 0.2) {
                self.likeButton.backgroundColor = .clear
            }
        }
    }
}
