//
//  ProfileProtocols.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 18.06.2024.
//

import Foundation

enum NetworkServiceError: Error {
    case codeError(_ value: String)
    case responseError(_ value: Int)
    case invalidRequest
}
