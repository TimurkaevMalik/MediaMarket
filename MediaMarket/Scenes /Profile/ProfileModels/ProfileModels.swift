//
//  ProfileModels.swift
//  MediaMarket
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
