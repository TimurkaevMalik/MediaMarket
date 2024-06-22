//
//  NftItem.swift
//  FakeNFT
//
//  Created by Artem Krasnov on 22.06.2024.
//

import Foundation

struct NftItem: Hashable, Codable {
    let id: UUID
    let name: String
    let rating: Int
    let price: Double
    let images: [URL]
    let isFavorite: Bool
}
