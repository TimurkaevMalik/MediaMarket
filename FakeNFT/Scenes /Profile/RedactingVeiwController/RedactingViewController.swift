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
    
    private var alertPresenter: AlertPresenter?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let alertType = AlertType.textFieldAlert(value: TextFieldAlert(viewController: self, delegate: self))
        alertPresenter = AlertPresenter(type: alertType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureUserPhoto()
    }
    
    @objc func userPhotoButtonTapped() {
        print("user photo button tapped")
        
        alertPresenter?.textFieldAlertController()
    }
    
    private func configureUserPhoto() {
        let image = UIImage(named: "avatarPlug")
        let title = "Сменить \n фото"
        userPhotoButton.tintColor = .clear
        userPhotoButton.setImage(image, for: .normal)
        
        userPhotoTitleLabel.text = title
        userPhotoTitleLabel.numberOfLines = 2
        userPhotoTitleLabel.textColor = .white
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

extension RedactingViewController: AlertDelegateProtocol {
    func alertSaveButtonTappep(text: String?) {
        
        guard
            let text = text,
            !text.filter({$0 != Character(" ")}).isEmpty 
        else {
            alertPresenter?.textFieldAlertController()
            return
        }
        print(text)
    }
}
