//
//  NFTFactory.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 25.06.2024.
//

import Foundation

final class NFTFactory {

    private weak var delegate: NFTFactoryDelegate?
    private let fetchNFTService = FetchNFTService.shared
    private let updateNFTService = UpdateNFTService.shared

    private let token = RequestConstants.token

    init(delegate: NFTFactoryDelegate) {
        self.delegate = delegate
    }

    func loadNFT(id: String) {

        fetchNFTService.fecthNFT(token, NFTId: id) { [weak self] result in

            guard let self else { return }

            switch result {
            case .success(let nft):
                self.delegate?.didRecieveNFT(nft)

            case .failure(let error):
                self.delegate?.didFailToLoadNFT(with: error)
            }
        }
    }

    func updateFavoriteNFTOnServer(_ nftIdArray: [String]) {

        UIBlockingProgressHUD.show()

        updateNFTService.updateFavoriteNFT(token, nftIdArray: nftIdArray) { [weak self] result in

            UIBlockingProgressHUD.dismiss()

            guard let self else { return }

            switch result {
            case .success(let favoriteNFTs):
                self.delegate?.didUpdateFavoriteNFT(favoriteNFTs)

            case .failure(let error):
                self.delegate?.didFailToUpdateFavoriteNFT(with: error)
            }
        }
    }
}
