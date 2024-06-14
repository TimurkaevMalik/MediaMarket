//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 13.06.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var userName = UILabel()
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
    }
    
    private func configureUserPhoto() {
        
        userPhoto.tintColor = UIColor(named: "YPBlack")
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.cornerRadius = 25
        
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
        userName.text = "Name wasn't found"
        userName.font = UIFont.headline3
        userName.textColor = UIColor(named: "YPBlack")
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
        
        NSLayoutConstraint.activate([
            userName.centerYAnchor.constraint(equalTo: userPhoto.centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor, constant: 16),
            userName.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
}
