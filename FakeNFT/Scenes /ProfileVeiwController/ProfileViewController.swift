//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 13.06.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var linkButton = UIButton()
    private lazy var redactButton = UIButton()
    private lazy var userName = UILabel()
    private lazy var userDescription = UITextView()
    private lazy var userPhoto = UIImageView(image: UIImage(systemName: "person.crop.circle"))
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        configureUserPhoto()
        configureUserName()
        configureRedactButton()
        configureUserDescription()
        configureLinkButton()
    }
    
    @objc func redactButtonTapped() {
        print("Redact button tapped")
    }
    
    @objc func linkButtonTapped() {
        print("Link button tapped")
    }
    
    private func configureUserPhoto() {
        userPhoto.tintColor = UIColor(named: "YPBlack")
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.cornerRadius = 35
        
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhoto)
        
        NSLayoutConstraint.activate([
            userPhoto.widthAnchor.constraint(equalToConstant: 70),
            userPhoto.heightAnchor.constraint(equalToConstant: 70),
            userPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            userPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureUserName() {
        userName.textColor = UIColor(named: "YPBlack")
        userName.text = "Name wasn't found"
        userName.font = UIFont.headline3
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
        
        NSLayoutConstraint.activate([
            userName.centerYAnchor.constraint(equalTo: userPhoto.centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor, constant: 16),
            userName.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureRedactButton() {
        redactButton.tintColor = UIColor(named: "YPBlack")
        redactButton.setImage(UIImage(named: "editButtonImage"), for: .normal)
        redactButton.addTarget(self, action: #selector(redactButtonTapped), for: .touchUpInside)
        
        redactButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redactButton)
        
        NSLayoutConstraint.activate([
            redactButton.widthAnchor.constraint(equalToConstant: 42),
            redactButton.heightAnchor.constraint(equalToConstant: 42),
            redactButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            redactButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
    }
    
    private func configureUserDescription() {
        userDescription.textColor = UIColor(named: "YPBlack")
        userDescription.backgroundColor = .clear
        userDescription.isEditable = false
        userDescription.isScrollEnabled = false
        userDescription.sizeToFit()
        
        userDescription.textContainer.lineFragmentPadding = 0
        userDescription.textAlignment = .left
        userDescription.textContainer.maximumNumberOfLines = 4
        userDescription.font = UIFont.caption2
        userDescription.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        
        userDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDescription)
        
        NSLayoutConstraint.activate([
            userDescription.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 20),
            userDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLinkButton() {
        linkButton.setTitleColor(UIColor(named: "YPBlue"), for: .normal)
        linkButton.setTitle("Link wasn't found", for: .normal)
        linkButton.titleLabel?.font = UIFont.caption1
        linkButton.contentHorizontalAlignment = .left
        
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(linkButton)
        
        NSLayoutConstraint.activate([
            linkButton.heightAnchor.constraint(equalToConstant: 20),
            linkButton.topAnchor.constraint(equalTo: userDescription.bottomAnchor, constant: 8),
            linkButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            linkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
