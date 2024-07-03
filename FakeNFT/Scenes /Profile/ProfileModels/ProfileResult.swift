//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 17.06.2024.
//

import Foundation

struct Profile: Codable {
    var name: String
    var avatar: String
    var description: String
    var website: String
    var nfts: [String]
    var likes: [String]
    var id: String
}
