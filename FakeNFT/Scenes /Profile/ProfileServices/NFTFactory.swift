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
    
    init(delegate: NFTFactoryDelegate) {
        self.delegate = delegate
    }
    
    func loadNFT(id: String) {
        
        let token = MalikToken.token
        
        fetchNFTService.fecthNFT(token, NFTId: id) { result in
            
            switch result {
            case .success(let nft):
                self.delegate?.didRecieveNFT(nft)
                
            case .failure(let error):
                self.delegate?.didFailToLoadNFT(with: error)
            }
        }
    }
}
