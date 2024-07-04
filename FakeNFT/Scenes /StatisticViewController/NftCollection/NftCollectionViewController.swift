import Foundation
import UIKit
import ProgressHUD


final class NftCollectionViewController: UIViewController {
    // MARK: - Private Properties
    private var nftsId = [String]()
    private var nfts = [NftStatistic]()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let titleBar = NSLocalizedString("Statistic.nftCollection.title", comment: "")
    private let statisticNetworkServise = StatisticNetworkServise()
    private let noNftText = NSLocalizedString("Statistic.nftCollection.noNft", comment: "")
    private let noNftLabel = UILabel()
    private let defaults = UserDefaults.standard
    
    // MARK: - Initializers
    init(nfts: [String]) {
        self.nftsId = nfts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        setupNavBar()
        if nftsId.isEmpty == false {
            setupCollectionView()
            setupConstraint()
            reloadNfts()
        } else {
            showNoNftLabel()
        }
    }
    
    // MARK: - Actions
    @objc private func onClickBackButton() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupNavBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(onClickBackButton))
        backButton.tintColor = .black
        self.navigationItem.title = titleBar
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(NftCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func showNoNftLabel() {
        view.addSubview(noNftLabel)
        noNftLabel.translatesAutoresizingMaskIntoConstraints = false
        noNftLabel.text = noNftText
        noNftLabel.font = UIFont.systemFont(ofSize: 25)
        setupConstraintNoNftLabel()
    }
    
    private func setupConstraintNoNftLabel() {
        NSLayoutConstraint.activate([
            noNftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noNftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func reloadNfts(){
        ProgressHUD.show()
        for id in nftsId {
            statisticNetworkServise.fetchNft(id: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nfts.append(nft)
                    if self?.nfts.count == self?.nftsId.count {
                        ProgressHUD.dismiss()
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    ProgressHUD.dismiss()
                    print("Error: \(error.localizedDescription)")
                    break
                }
            }
        }
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension NftCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = cell as? NftCollectionViewCell else {
            return NftCollectionViewCell()
        }
        cell.delegate = self
        cell.updateNameLabel(name: nfts[indexPath.item].name)
        cell.updatePriceLabel(price: "\(nfts[indexPath.item].price) ETH")
        cell.updateRatingLabel(rating: nfts[indexPath.item].rating)
        if let nftURL = URL(string: nfts[indexPath.item].images[0]) {
            cell.updateNftImage(image: nftURL)
        }
        let isLike = defaults.bool(forKey: "isLike \(nfts[indexPath.item].id)")
        if isLike {
            cell.updateLikeButton(image: UIImage(named: "redHeart") ?? UIImage())
        } else {
            cell.updateLikeButton(image: UIImage(named: "whiteHeart") ?? UIImage())
        }
        let isCart = defaults.bool(forKey: "isCart \(nfts[indexPath.item].id)")
        if isCart {
            cell.updateCartButton(image: UIImage(named: "crossCart") ?? UIImage())
        } else {
            cell.updateCartButton(image: UIImage(named: "emptyCart") ?? UIImage())
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108,
                      height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - NftCollectionViewCellDelegate
extension NftCollectionViewController: NftCollectionViewCellDelegate {
    func changeLike(_ cell: NftCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell)
        else { return }
        let isLike = defaults.bool(forKey: "isLike \(nfts[indexPath.item].id)")
        if isLike {
            //TODO заменить defaults на реально используемое в эпике Профиль(при добавлении в избранное)
            defaults.set(false, forKey: "isLike \(nfts[indexPath.item].id)")
            cell.updateLikeButton(image: UIImage(named: "whiteHeart") ?? UIImage())
        } else {
            defaults.set(true, forKey: "isLike \(nfts[indexPath.item].id)")
            cell.updateLikeButton(image: UIImage(named: "redHeart") ?? UIImage())
        }
    }
    
    func changeCart(_ cell: NftCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell)
        else { return }
        let isCart = defaults.bool(forKey: "isCart \(nfts[indexPath.item].id)")
        if isCart {
            //TODO заменить defaults на реально используемое в эпике Корзина(при добавлении в корзину)
            defaults.set(false, forKey: "isCart \(nfts[indexPath.item].id)")
            cell.updateCartButton(image: UIImage(named: "emptyCart") ?? UIImage())
        } else {
            defaults.set(true, forKey: "isCart \(nfts[indexPath.item].id)")
            cell.updateCartButton(image: UIImage(named: "crossCart") ?? UIImage())
        }
    }
}
