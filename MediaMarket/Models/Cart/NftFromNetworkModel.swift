//
//  NftFromNetworkModel.swift
//  MediaMarket
//
//  Created by Олег Спиридонов on 16.06.2024.
//

import Foundation

struct NftFromNetworkModel: Codable {
    let createdAt, name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
