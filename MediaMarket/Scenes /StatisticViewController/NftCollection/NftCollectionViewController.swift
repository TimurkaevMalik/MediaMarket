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
    private var nftsInOrder = [OrderStat]()
    private var likes = [LikeStat]()
    
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
        if !nftsId.isEmpty {
            setupCollectionView()
            setupConstraint()
            reloadNfts()
            reloadLikes()
            reloadCart()
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
    
    private func reloadLikes(){
        ProgressHUD.show()
        statisticNetworkServise.fetchLike() { [weak self] result in
            switch result {
            case .success(let likes):
                ProgressHUD.dismiss()
                self?.likes.append(likes)
                self?.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.dismiss()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateLike(){
        ProgressHUD.show()
        statisticNetworkServise.updateLike(ids: likes[0]) { [weak self] result in
            switch result {
            case .success():
                ProgressHUD.dismiss()
                self?.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.dismiss()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func reloadCart(){
        ProgressHUD.show()
        statisticNetworkServise.fetchCart() { [weak self] result in
            switch result {
            case .success(let ndtsInOrder):
                ProgressHUD.dismiss()
                self?.nftsInOrder.append(ndtsInOrder)
                self?.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.dismiss()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateCart(){
        ProgressHUD.show()
        statisticNetworkServise.updateCart(ids: nftsInOrder[0]) { [weak self] result in
            switch result {
            case .success():
                ProgressHUD.dismiss()
                self?.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.dismiss()
                print("Error: \(error.localizedDescription)")
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
        if !likes.isEmpty {
            if likes[0].likes.contains(nfts[indexPath.item].id) {
                cell.updateLikeImage(image: UIImage(named: "redHeart") ?? UIImage())
            } else {
                cell.updateLikeImage(image: UIImage(named: "whiteHeart") ?? UIImage())
            }
        }
        if !nftsInOrder.isEmpty {
            if nftsInOrder[0].nfts.contains(nfts[indexPath.item].id) {
                cell.updateCartButton(image: UIImage(named: "crossCart") ?? UIImage())
            } else {
                cell.updateCartButton(image: UIImage(named: "emptyCart") ?? UIImage())
            }
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
        if !likes.isEmpty {
            if likes[0].likes.contains(nfts[indexPath.item].id) {
                let deleteNftIndex = likes[0].likes.firstIndex(of: nfts[indexPath.item].id) ?? Int()
                likes[0].likes.remove(at: deleteNftIndex)
                updateLike()
            } else {
                likes[0].likes.append(nfts[indexPath.item].id)
                updateLike()
            }
        } else {
            nftsInOrder[0].nfts.append(nfts[indexPath.item].id)
            updateCart()
        }
    }
    
    func changeCart(_ cell: NftCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell)
        else { return }
        if !nftsInOrder.isEmpty {
            if nftsInOrder[0].nfts.contains(nfts[indexPath.item].id) {
                let deleteNftIndex = nftsInOrder[0].nfts.firstIndex(of: nfts[indexPath.item].id) ?? Int()
                nftsInOrder[0].nfts.remove(at: deleteNftIndex)
                updateCart()
            } else {
                nftsInOrder[0].nfts.append(nfts[indexPath.item].id)
                updateCart()
            }
        } else {
            nftsInOrder[0].nfts.append(nfts[indexPath.item].id)
            updateCart()
        }
    }
}
