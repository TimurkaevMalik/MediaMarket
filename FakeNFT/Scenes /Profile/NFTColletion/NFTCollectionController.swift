//
//  NFTCollectionController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 25.06.2024.
//

import UIKit


final class NFTCollectionController: UIViewController {
    
    private lazy var titleLabel = UILabel()
    private lazy var topViewsContainer = UIView()
    private lazy var centralPlugLabel = UILabel()
    private lazy var closeButton = UIButton()
    
    
    private var nftIdArray: [String]
    private var likedNFTIdArray: [String]
    
    init(nftIdArray: [String], likedNftIdArray: [String]){
        self.nftIdArray = nftIdArray
        self.likedNFTIdArray = likedNftIdArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        configureCentralPlugLabel()
        configureTopViewsContainer()
        configureTitleLabel()
        configureCloseButton()
    }
    
    @objc func closeControllerButtonTapped() {
        dismiss(animated: true)
    }
    
    private func configureTopViewsContainer() {
        topViewsContainer.backgroundColor = .ypWhite
        topViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topViewsContainer)
        
        NSLayoutConstraint.activate([
            topViewsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewsContainer.heightAnchor.constraint(equalToConstant: 42),
            topViewsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    private func configureTitleLabel(){
        titleLabel.textColor = .ypBlack
        titleLabel.text = "Мои NFT"
        titleLabel.font = UIFont.bodyBold
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor)
        ])
    }
    
    private func configureCentralPlugLabel(){
        centralPlugLabel.textColor = .ypBlack
        
        centralPlugLabel.text = "У вас ещё нет NFT"
        centralPlugLabel.textAlignment = .center
        centralPlugLabel.font = .bodyBold
        centralPlugLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centralPlugLabel)
        
        NSLayoutConstraint.activate([
            centralPlugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralPlugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            centralPlugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centralPlugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ])
    }
    
    private func configureCloseButton() {
        let image = UIImage(systemName: "chevron.backward")
        closeButton.tintColor = .ypBlack
        
        closeButton.setImage(image, for: .normal)
        closeButton.addTarget(self, action: #selector(closeControllerButtonTapped), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: topViewsContainer.leadingAnchor, constant: 9)
        ])
    }
}
