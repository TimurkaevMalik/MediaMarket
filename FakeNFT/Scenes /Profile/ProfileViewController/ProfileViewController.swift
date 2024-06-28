//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 13.06.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private lazy var tableView = UITableView()
    private lazy var linkButton = UIButton()
    private lazy var redactButton = UIButton(type: .system)
    private lazy var userNameLabel = UILabel()
    private lazy var userDescriptionView = UITextView()
    private lazy var userPhotoView = UIImageView(image: UIImage(named: "avatarPlug"))
    
    private let servicesAssembly: ServicesAssembly
    private var profileFactory: ProfileFactory?
    private var profile: Profile?
    private var alertPresenter: AlertPresenter?
    private let tableCellIdentifier = "tableCellIdentifier"
    private let tableViewCells = ["Мои NFT", "Избранные NFT", "О разработчике"]
    
    private var nftIdArray: [String] = []
    private var favoriteNFTsId: [String] = []
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
        
        profileFactory = ProfileFactory(delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureUserPhoto()
        configureUserName()
        configureRedactButton()
        configureUserDescription()
        configureLinkButton()
        configureTableView()
        fetchProfile()
    }
    
    @objc func redactButtonTapped() {
        guard let profile else { return }
        let viewController = RedactingViewController(profile: profile, delegate: self)
        present(viewController, animated: true)
    }
    
    @objc func linkButtonTapped() {
        print("Link button tapped")
    }
    
    private func configureUserPhoto() {
        userPhotoView.layer.masksToBounds = true
        userPhotoView.layer.cornerRadius = 35
        userPhotoView.clipsToBounds = true
        userPhotoView.contentMode = .scaleAspectFill
        
        userPhotoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhotoView)
        
        NSLayoutConstraint.activate([
            userPhotoView.widthAnchor.constraint(equalToConstant: 70),
            userPhotoView.heightAnchor.constraint(equalToConstant: 70),
            userPhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            userPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureUserName() {
        userNameLabel.textColor = .ypBlack
        userNameLabel.font = UIFont.headline3
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.centerYAnchor.constraint(equalTo: userPhotoView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureRedactButton() {
        redactButton.tintColor = .ypBlack
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
        userDescriptionView.backgroundColor = .clear
        userDescriptionView.isEditable = false
        userDescriptionView.isScrollEnabled = false
        userDescriptionView.sizeToFit()
        
        userDescriptionView.textContainer.lineFragmentPadding = 0
        userDescriptionView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        userDescriptionView.textAlignment = .left
        userDescriptionView.textContainer.maximumNumberOfLines = 5
        
        let text = "Поиск описания"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing =  3
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          .foregroundColor: UIColor.ypBlack,
                          .font: UIFont.caption2
        ]
        
        userDescriptionView.attributedText = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        
        userDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDescriptionView)
        
        NSLayoutConstraint.activate([
            userDescriptionView.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: 20),
            userDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLinkButton() {
        linkButton.setTitleColor(.ypBlue, for: .normal)
        linkButton.titleLabel?.font = UIFont.caption1
        linkButton.contentHorizontalAlignment = .left
        
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(linkButton)
        
        NSLayoutConstraint.activate([
            linkButton.heightAnchor.constraint(equalToConstant: 20),
            linkButton.topAnchor.constraint(equalTo: userDescriptionView.bottomAnchor, constant: 8),
            linkButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            linkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 44),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 162),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchProfile() {
        setFetchigInfoTiltesForViews()
        profileFactory?.loadProfile()
    }
    
    private func updateProfile(_ profile: Profile) {
        profileFactory?.updateProfileOnServer(profile)
    }
    
    private func updateControllerProfile(_ profile: Profile) {
        self.profile = profile
        nftIdArray = profile.nfts
        favoriteNFTsId = profile.likes
        
        userNameLabel.text = profile.name
        userDescriptionView.text = profile.description
        linkButton.setTitle(profile.website, for: .normal)
        
        updateUserPhotoWith(url: profile.avatar)
        
        tableView.reloadData()
    }
    
    private func updateUserPhotoWith(url: String) {
        guard let avatarUrl = URL(string: url) else {
            return
        }
        userPhotoView.kf.setImage(with: avatarUrl)
    }
    
    private func setDefaultTitlesForViews() {
        userNameLabel.text = "Имя не найдено"
        userDescriptionView.text = "Описание не найдено"
        linkButton.setTitle("Ссылка не найдена", for: .normal)
    }
    
    private func setFetchigInfoTiltesForViews() {
        userNameLabel.text = "Поиск имени"
        userDescriptionView.text = "Поиск описания"
        linkButton.setTitle("Поиск ссылки сайта", for: .normal)
    }
    
    private func showServiceErrorAlert(_ error: NetworkServiceError, completion: @escaping () -> Void) {
        let errorString: String
        
        switch error {
            
        case .codeError(let value):
            errorString = value
        case .responseError(let value):
            errorString = "\(value)"
        case .invalidRequest:
            errorString = "Unknown error"
        }
        
        let message = "Не удалось обновить профиль"
        
        let model = AlertModel(
            title: "Ошибка: \(errorString)",
            message: message,
            closeAlertTitle: "Закрыть",
            completionTitle: "Повторить") {
                completion()
            }
        
        self.alertPresenter?.defaultAlert(model: model)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as? ProfileTableCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.cellTextLabel.text = tableViewCells[indexPath.row] + " " + "(\(nftIdArray.count))"
        } else if indexPath.row == 1 {
            cell.cellTextLabel.text = tableViewCells[indexPath.row] + " " + "(\(favoriteNFTsId.count))"
        } else {
            cell.cellTextLabel.text = tableViewCells[indexPath.row]
        }
        
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            let viewController = NFTCollectionController(delegate: self, nftIdArray: nftIdArray, favoriteNFTsId: favoriteNFTsId)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
            
        } else if indexPath.row == 1 {
            
            let viewController = FavoriteNFTController(delegate: self, favoriteNFTsId: favoriteNFTsId)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
            
        } else if indexPath.row == 2,
                  let website = profile?.website,
                  let url = URL(string: website) {
            
            let viewController = WebViewController(webViewURL: url)
            present(viewController, animated: true)
        }
    }
}

extension ProfileViewController: ProfileControllerDelegate {
    func didEndRedactingProfile(_ profile: Profile) {
        
        guard didProfileInfoChanged(profile) else { return }
        
        guard 
            profile.name.count >= 2,
            profile.website.count >= 7
        else {
            let requirmentText = "Требования:"
            let nameRequirement =        "• Имя: 2-38 символов                  •"
            let websiteLinkRequirement = "• Cсылка сайта: 7-38 символов •"
            let messageRequirement = requirmentText + "\n" + nameRequirement + "\n" + websiteLinkRequirement
            
            let messageAdvice = "Если ссылка сайта не вмещается в заданый дипазон, можете сократить количетсво символов, сделав её гиперссылкой"
            
            let message = messageRequirement + "\n" + "\n" + messageAdvice
            
            let model = AlertModel(
                title: "Ошибка обновления профиля",
                message: message,
                closeAlertTitle: "Закрыть",
                completionTitle: "Вренутся") {
                    self.backToRedact(profile: profile)
                }
            
            alertPresenter?.defaultAlert(model: model)
            return
        }
        
        updateProfile(profile)
    }
    
    private func didProfileInfoChanged(_ profile: Profile) -> Bool {
        
        guard
            let oldProfile = self.profile,
            oldProfile.name == profile.name,
            oldProfile.website == profile.website,
            oldProfile.avatar == profile.avatar,
            oldProfile.description == profile.description
        else { return true }
        
        return false
    }
    
    private func backToRedact(profile: Profile) {
        let viewController = RedactingViewController(profile: profile, delegate: self)
        present(viewController, animated: true)
    }
}

extension ProfileViewController: ProfileFactoryDelegate {
    func didExecuteRequest(_ profile: Profile) {
        self.updateControllerProfile(profile)
    }
    
    func didFailToLoadProfile(with error: NetworkServiceError) {
        setDefaultTitlesForViews()
        showServiceErrorAlert(error) {
            self.fetchProfile()
        }
    }
    
    func didFailToUpdateProfile(with error: NetworkServiceError) {
        
        if let profile = UpdateProfileService.profileResult {
            
        showServiceErrorAlert(error) {
                self.updateProfile(profile)
            }
        } else if let profile = self.profile {
            
            let model = AlertModel(
                title: "Неизвестная ошбика",
                message: "Попробуйте отредактировать ещё раз",
                closeAlertTitle: "Отмена",
                completionTitle: "Вернуться") {
                    self.backToRedact(profile: profile)
                }
            
            alertPresenter?.defaultAlert(model: model)
        }
    }
}

extension ProfileViewController: NFTCollectionControllerDelegate {
    func didUpdateFavoriteNFT(_ nftIdArray: [String]) {
        favoriteNFTsId = nftIdArray
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
}
