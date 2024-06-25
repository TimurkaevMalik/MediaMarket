//
//  ProfileModels.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 19.06.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String?
    let closeAlertTitle: String
    let completionTitle: String
    
    let completion: () -> Void
}

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
