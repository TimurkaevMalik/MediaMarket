import Foundation
import UIKit
import Kingfisher


final class UserCardViewController: UIViewController {
    
    // MARK: - Private Properties
    private var avatar = String()
    private var name = String()
    private var website = String()
    private var descriptionUser = String()
    private var nfts = [String]()
    private let avatarImage = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let websiteButton = UIButton()
    private let titleWebsiteButton = NSLocalizedString("Statistic.userCard.website", comment: "")
    private lazy var nftsTableView: UITableView = {
        let table = UITableView()
        table.register(UserCardTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // MARK: - Initializers
    init(avatar: String, name: String, descriptionUser: String, website: String, nfts: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.avatar = avatar
        self.name = name
        self.descriptionUser = descriptionUser
        self.website = website
        self.nfts = nfts
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        setupNavBar()
        setupAvatarImage()
        setupNameLabel()
        setupDescriptionLabel()
        setupWebsiteButton()
        setupNftsTableView()
        setupConstraint()
    }
    
    // MARK: - Actions
    @objc private func onClickBackButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func onClickWebsiteButton() {
        let viewController = WebViewViewController(website: website)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupNavBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(onClickBackButton))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupAvatarImage() {
        view.addSubview(avatarImage)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.backgroundColor = .clear
        avatarImage.layer.cornerRadius = 35
        avatarImage.layer.masksToBounds = true
        if let avatarURL = URL(string: avatar) {
            avatarImage.kf.indicatorType = .activity
            avatarImage.kf.setImage(with: avatarURL, placeholder: UIImage(named: "ProfileImage"))
        } else {
            avatarImage.image = UIImage(named: "ProfileImage")
        }
    }
    
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        nameLabel.text = name
    }
    
    private func setupDescriptionLabel() {
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.text = descriptionUser
    }
    
    private func setupWebsiteButton() {
        view.addSubview(websiteButton)
        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        websiteButton.backgroundColor = .clear
        websiteButton.addTarget(self,
                                action: #selector(onClickWebsiteButton),
                                for: .touchUpInside)
        websiteButton.layer.cornerRadius = 16
        websiteButton.layer.masksToBounds = true
        websiteButton.setTitle(titleWebsiteButton, for: .normal)
        websiteButton.setTitleColor(UIColor(named: "YPBlack"), for: .normal)
        websiteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        websiteButton.titleLabel?.textAlignment = .center
        websiteButton.layer.borderWidth = 1
        websiteButton.layer.borderColor = UIColor(named: "YPBlack")?.cgColor
    }
    
    private func setupNftsTableView() {
        view.addSubview(nftsTableView)
        nftsTableView.translatesAutoresizingMaskIntoConstraints = false
        nftsTableView.separatorStyle = .none
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            websiteButton.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 120),
            websiteButton.heightAnchor.constraint(equalToConstant: 40),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftsTableView.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            nftsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension UserCardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = cell as? UserCardTableViewCell else {
            return UserCardTableViewCell()
        }
        cell.updateNumberNftLabel(text: String(nfts.count))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = NftCollectionViewController(nfts: nfts)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
}
