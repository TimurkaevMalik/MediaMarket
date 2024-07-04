import Foundation
import UIKit
import Kingfisher


protocol NftCollectionViewCellDelegate: AnyObject {
    func changeLike(_ cell: NftCollectionViewCell)
    func changeCart(_ cell: NftCollectionViewCell)
}

final class NftCollectionViewCell: UICollectionViewCell {
    // MARK: - Public Properties
    weak var delegate: NftCollectionViewCellDelegate?
    
    // MARK: - Private Properties
    private let nftImage = UIImageView()
    private let rating = UIStackView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let likeButton = UIButton()
    private let cartButton = UIButton()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "YPWhite")
        setupNftImage()
        setupRating()
        setupLikeButton()
        setupCartButton()
        setupNameLabel()
        setupPriceLabel()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func onClickLikeButton() {
        delegate?.changeLike(self)
        //TODO добавление в избранное
    }
    
    @objc private func onClickCartButton() {
        delegate?.changeCart(self)
        //TODO добавление в корзину
    }
    
    // MARK: - Public Methods
    func updateNameLabel(name: String){
        nameLabel.text = name
    }
    
    func updatePriceLabel(price: String){
        priceLabel.text = price
    }
    
    func updateRatingLabel(rating: Int){
        for count in 0..<5 {
            if count < rating {
                if let starImageView = self.rating.arrangedSubviews[count] as? UIImageView {
                    starImageView.tintColor = UIColor(named: "YPYellow")
                }
            } else {
                if let starImageView = self.rating.arrangedSubviews[count] as? UIImageView {
                    starImageView.tintColor = UIColor(named: "YPLightGray")
                }
            }
        }
    }
    
    func updateNftImage(image: URL){
        nftImage.kf.indicatorType = .activity
        nftImage.kf.setImage(with: image)
    }
    
    func updateLikeButton(image: UIImage){
        likeButton.setImage(image, for: .normal)
    }
    
    func updateCartButton(image: UIImage){
        cartButton.setImage(image, for: .normal)
    }
    
    // MARK: - Private Methods
    private func setupNftImage(){
        contentView.addSubview(nftImage)
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
    }
    
    private func setupRating(){
        contentView.addSubview(rating)
        rating.axis = .horizontal
        rating.distribution = .fillEqually
        rating.spacing = 2
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(named: "emptyGoldStar")?.withRenderingMode(.alwaysTemplate))
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            rating.addArrangedSubview(starImageView)
        }
    }
    
    private func setupLikeButton(){
        contentView.addSubview(likeButton)
        likeButton.backgroundColor = .clear
        likeButton.setImage(UIImage(named: "whiteHeart"), for: .normal)
        likeButton.addTarget(self,
                             action: #selector(onClickLikeButton),
                             for: .touchUpInside)
    }
    
    private func setupCartButton(){
        contentView.addSubview(cartButton)
        cartButton.backgroundColor = .clear
        cartButton.setImage(UIImage(named: "emptyCart"), for: .normal)
        cartButton.addTarget(self,
                             action: #selector(onClickCartButton),
                             for: .touchUpInside)
    }
    
    private func setupNameLabel(){
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.numberOfLines = 2
    }
    
    private func setupPriceLabel(){
        contentView.addSubview(priceLabel)
        priceLabel.font = UIFont.systemFont(ofSize: 10)
    }
    
    private func setupConstraint(){
        [nftImage, rating, nameLabel, priceLabel, likeButton, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: topAnchor),
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            
            rating.leadingAnchor.constraint(equalTo: leadingAnchor),
            rating.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            rating.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            rating.heightAnchor.constraint(equalToConstant: 12),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            nameLabel.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 4),
            
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartButton.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 4),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
