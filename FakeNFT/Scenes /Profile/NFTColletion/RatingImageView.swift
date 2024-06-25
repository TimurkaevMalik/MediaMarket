//
//  RatingImageView.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 25.06.2024.
//

import UIKit
import Kingfisher

final class RatingImageView: UIImageView {
    
    private let firstImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private let secondImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private let thirdImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private let fourthImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private let fifthImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    
    private var ratingImageViews: [UIImageView] = []
    private let ratingNumber: Int
    
    init(frame: CGRect, ratingNumber: Int) {
        self.ratingNumber = ratingNumber
        super.init(frame: frame)
        
        ratingImageViews.append(firstImageView)
        ratingImageViews.append(secondImageView)
        ratingImageViews.append(thirdImageView)
        ratingImageViews.append(fourthImageView)
        ratingImageViews.append(fifthImageView)
        
        viewAddImageViews()
        configureImageVeiwsConstraints()
        setImageViewsContentMode()
        updateImageViewsImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    private func viewAddImageViews() {
        
        for ratingImageView in ratingImageViews {
            ratingImageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(ratingImageView)
        }
    }
    
    private func configureImageVeiwsConstraints() {
        
        NSLayoutConstraint.activate([
            firstImageView.topAnchor.constraint(equalTo: self.topAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            firstImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            firstImageView.widthAnchor.constraint(equalToConstant: firstImageView.frame.height),
            
            secondImageView.topAnchor.constraint(equalTo: self.topAnchor),
            secondImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            secondImageView.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor, constant: 2),
            secondImageView.widthAnchor.constraint(equalToConstant: firstImageView.frame.height),
            
            thirdImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thirdImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thirdImageView.leadingAnchor.constraint(equalTo: secondImageView.trailingAnchor, constant: 2),
            thirdImageView.widthAnchor.constraint(equalToConstant: firstImageView.frame.height),
            
            fourthImageView.topAnchor.constraint(equalTo: self.topAnchor),
            fourthImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            fourthImageView.leadingAnchor.constraint(equalTo: thirdImageView.trailingAnchor, constant: 2),
            fourthImageView.widthAnchor.constraint(equalToConstant: firstImageView.frame.height),
            
            fifthImageView.topAnchor.constraint(equalTo: self.topAnchor),
            fifthImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            fifthImageView.leadingAnchor.constraint(equalTo: fourthImageView.trailingAnchor, constant: 2),
            fifthImageView.widthAnchor.constraint(equalToConstant: firstImageView.frame.height),
        ])
        
    }
    
    private func setImageViewsContentMode() {
        
        for ratingImageView in ratingImageViews {
            ratingImageView.clipsToBounds = true
            ratingImageView.contentMode = .scaleAspectFill
        }
    }
    
    private func updateImageViewsImages() {
        
        for number in 0..<ratingNumber {
            if ratingImageViews.count - 1 >= number {
                ratingImageViews[number].image = UIImage(named: "goldStar")
            }
        }
    }
}
