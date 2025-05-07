//
//  NftInCart.swift
//  MediaMarket
//
//  Created by Олег Спиридонов on 15.06.2024.
//

import Foundation
import UIKit

struct NftInCartModel {
    let id: String
    let name: String
    let rating: Int
    let price: Double
    let picture: String
}

extension Array where Element == NftInCartModel {
    func sortedByPrice() -> [NftInCartModel] {
        return self.sorted { $0.price < $1.price }
    }

    func sortedByRating() -> [NftInCartModel] {
        return self.sorted { $0.rating > $1.rating }
    }

    func sortedByName() -> [NftInCartModel] {
        return self.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }
}
