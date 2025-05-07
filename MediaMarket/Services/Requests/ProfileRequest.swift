//
//  ProfileRequest.swift
//  MediaMarket
//
//  Created by Malik Timurkaev on 17.06.2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
}
