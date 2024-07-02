//
//  OrderModel.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 16.06.2024.
//

import Foundation

struct OrderModel: Codable {
    let nfts: [String]
    let id: String
}
