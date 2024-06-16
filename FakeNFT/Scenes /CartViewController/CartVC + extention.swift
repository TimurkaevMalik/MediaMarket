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
        mokNfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NftInCartCell()
        cell.setupCell(nftModel: mokNfts[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - NftInCartCellDelegate

extension CartViewController: NftInCartCellDelegate {
    
    func deleteNftFromCart(nftModel: NftInCartModel) {
        let vc = DeleteNftFromCartViewController()
        vc.image = nftModel.picture
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
            sceneDelegate.addBlurEffectToWindow()
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false) {
            vc.view.alpha = 0
            UIView.animate(withDuration: 0.3) {
                vc.view.alpha = 1
            }
        }
    }
}
