//
//  CartVC + extention.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 15.06.2024.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NftInCartCell()
        cell.setupCell(nftModel: nfts[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - NftInCartCellDelegate

extension CartViewController: NftInCartCellDelegate {

    func deleteNftFromCart(nftModel: NftInCartModel) {
        let vc = DeleteNftFromCartViewController()
        vc.delegate = self
        vc.nftModel = nftModel
        turnOnBlurEffect()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false) {
            vc.view.alpha = 0
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard self != nil else { return }
                vc.view.alpha = 1
            }
        }
    }
}

extension CartViewController: DeleteNftFromCartViewControllerDelegate {

    func deleteNft(nftModel: NftInCartModel) {
        var newArrayNftId: [String] = []
        nfts.forEach { nft in
            if nft.id != nftModel.id {
                newArrayNftId.append(nft.id)
            }
        }
        cartNetworkService.deleteNFTFromBasket(nftID: newArrayNftId) { [weak self] result in
            switch result {
            case .success:
                self?.reloadNfts()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func turnOffBlurEffect() {
        blurEffectView.isHidden = true
    }
}
