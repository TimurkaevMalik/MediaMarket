//
//  RatingView.swift
//  FakeNFT
//
//  Created by Artem Krasnov on 22.06.2024.
//

import UIKit

final class RatingView: UIStackView {

    // MARK: - Private Properties

    private let starCount = 5

    private var rating: Int = 0 {
        didSet {
            updateRating()
        }
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setRating(_ rating: Int) {
        guard rating >= 0 && rating <= starCount else { return }
        self.rating = rating
    }

    // MARK: - Private Methods

    private func commonInit() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 2

        for _ in 0..<starCount {
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: "emptyGoldStar")?.withRenderingMode(.alwaysTemplate)
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(starImageView)

            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }

        updateRating()
    }

    private func updateRating() {
        for count in 0..<starCount {
            if count < rating {
                if let starImageView = arrangedSubviews[count] as? UIImageView {
                    starImageView.tintColor = .yellowUniversal
                }
            } else {
                if let starImageView = arrangedSubviews[count] as? UIImageView {
                    starImageView.tintColor = .yaLightGrayLight
                }
            }
        }
    }
}
