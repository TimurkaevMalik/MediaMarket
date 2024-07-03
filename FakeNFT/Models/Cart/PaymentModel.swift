//
//  PaymentModel.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 20.06.2024.
//

import Foundation

struct PaymentModel: Codable {
    let success: Bool
    let orderID, id: String

    enum CodingKeys: String, CodingKey {
        case success
        case orderID = "orderId"
        case id
    }
}
