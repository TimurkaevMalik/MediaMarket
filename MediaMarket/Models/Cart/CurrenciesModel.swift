//
//  CurrenciesModel.swift
//  MediaMarket
//
//  Created by Олег Спиридонов on 20.06.2024.
//

import Foundation

struct CurrenciesModelElement: Codable {
    let title, name: String
    let image: String
    let id: String
}

typealias CurrenciesModel = [CurrenciesModelElement]
