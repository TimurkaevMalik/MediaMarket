//
//  RedactingViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 15.06.2024.
//

import UIKit

final class RedactingViewController: UIViewController {
    
    private lazy var userPhotoButton = UIButton()
    private lazy var userPhotoTitleLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureUserPhoto()
    }
    
    @objc func userPhotoButtonTapped() {
        print("user photo button tapped")
    }
    
    private func configureUserPhoto() {
        let image = UIImage(named: "avatarPlug")
        let title = "Сменить \n фото"
        userPhotoButton.tintColor = .clear
        userPhotoButton.setImage(image, for: .normal)
        
        userPhotoTitleLabel.text = title
        userPhotoTitleLabel.numberOfLines = 2
        userPhotoTitleLabel.textColor = .ypWhite
        userPhotoTitleLabel.textAlignment = .center
        userPhotoTitleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        userPhotoButton.layer.masksToBounds = true
        userPhotoButton.layer.cornerRadius = 35
        userPhotoButton.clipsToBounds = true
        userPhotoButton.contentMode = .scaleAspectFill
        
        userPhotoButton.addTarget(self, action: #selector(userPhotoButtonTapped), for: .touchUpInside)
        userPhotoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhotoButton)
        userPhotoButton.addSubview(userPhotoTitleLabel)
        
        NSLayoutConstraint.activate([
            userPhotoButton.widthAnchor.constraint(equalToConstant: 70),
            userPhotoButton.heightAnchor.constraint(equalToConstant: 70),
            userPhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -602),
            userPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userPhotoTitleLabel.centerXAnchor.constraint(equalTo: userPhotoButton.centerXAnchor),
            userPhotoTitleLabel.centerYAnchor.constraint(equalTo: userPhotoButton.centerYAnchor)
        ])
    }
    
}
