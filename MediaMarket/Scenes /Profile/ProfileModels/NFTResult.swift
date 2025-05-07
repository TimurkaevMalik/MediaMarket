//
//  NFTResult.swift
//  MediaMarket
//
//  Created by Malik Timurkaev on 26.06.2024.
//

import Foundation

struct NFTResult: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
