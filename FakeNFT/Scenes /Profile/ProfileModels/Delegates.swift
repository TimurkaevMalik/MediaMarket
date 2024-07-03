//
//  Delegates.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 18.06.2024.
//

import UIKit

protocol ProfileFactoryDelegate: AnyObject {
    func didExecuteRequest(_ profile: Profile)
    func didFailToLoadProfile(with error: NetworkServiceError)
    func didFailToUpdateProfile(with error: NetworkServiceError)
}

protocol NFTFactoryDelegate: AnyObject {
    func didRecieveNFT(_ nft: NFTResult)
    func didUpdateFavoriteNFT(_ favoriteNFTs: FavoriteNFTResult)
    func didFailToLoadNFT(with error: NetworkServiceError)
    func didFailToUpdateFavoriteNFT(with error: NetworkServiceError)
}

protocol SortAlertDelegate: AnyObject {
    func sortByPrice()
    func sortByRate()
    func sortByName()
}

protocol FetchNFTAlertDelegate {
    func tryToReloadNFT()
    func loadRestOfNFT()
    func closeActionTapped()
}

protocol TextFieldAlertDelegate: UIViewController {
    func alertSaveTextButtonTappep(text: String?)
}

protocol CollectionViewCellDelegate: AnyObject {
    func cellLikeButtonTapped(_ cell: UICollectionViewCell)
}

protocol ProfileControllerDelegate: AnyObject {
    func didEndRedactingProfile(_ profile: Profile)
}

protocol NFTCollectionControllerDelegate: AnyObject {
    func didUpdateFavoriteNFT(_ nftIdArray: [String])
}
