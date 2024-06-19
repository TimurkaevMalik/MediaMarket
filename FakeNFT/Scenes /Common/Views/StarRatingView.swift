//
//  StarRatingView.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 15.06.2024.
//

import Foundation
import UIKit

final class StarRatingView: UIView {
    
    // MARK: - Public Properties
    
    var rating: Int = 0 {
        didSet {
            updateStars()
        }
    }
    
    // MARK: - Private Properties
    
    private var starsStackView: UIStackView!
    private let filledStarImage = UIImage(named: "filledStarImage")
    private let emptyStarImage = UIImage(named: "emptyStarImage")
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        starsStackView = UIStackView()
        starsStackView.axis = .horizontal
        starsStackView.alignment = .fill
        starsStackView.distribution = .fillEqually
        starsStackView.spacing = 2
        addSubview(starsStackView)
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starsStackView.topAnchor.constraint(equalTo: topAnchor),
            starsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            starsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            starsStackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 12),
                imageView.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
        updateStars()
    }
    
    private func updateStars() {
        for (index, view) in starsStackView.arrangedSubviews.enumerated() {
            if let imageView = view as? UIImageView {
                imageView.image = index < rating ? filledStarImage : emptyStarImage
                imageView.tintColor = index < rating ? .yellow : .gray
            }
        }
    }
}

