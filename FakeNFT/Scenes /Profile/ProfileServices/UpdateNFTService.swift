//
//  UpdateFavoriteNFT.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 26.06.2024.
//

import Foundation


import UIKit

final class UpdateNFTService {

    private(set) static var nftResult: FavoriteNFTResult?
    static let shared = UpdateNFTService()

    private var task: URLSessionTask?

    private init() {}

    func updateProfile(_ token: String, nftIdArray: [String], completion: @escaping (Result<FavoriteNFTResult,NetworkServiceError>) -> Void) {

        assert(Thread.isMainThread)

        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeRequestBody(nftIdArray: nftIdArray, token: token) else {
            completion(.failure(NetworkServiceError.codeError("Uknown Error")))
            return
        }
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            DispatchQueue.main.async { [weak self] in

                guard let self = self else {return}

                self.task = nil
                
                if error != nil {
                    
                    completion(.failure(NetworkServiceError.codeError("Unknown error")))
                    return
                }

                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode  >= 300 {
                    
                    completion(.failure(NetworkServiceError.responseError(response.statusCode)))
                    return
                }

                if let data = data {

                    do {
                        let nftResultInfo = try JSONDecoder().decode(FavoriteNFTResult.self, from: data)

                        UpdateNFTService.nftResult = nftResultInfo
                        completion(.success(nftResultInfo))
                    } catch {
                        completion(.failure(NetworkServiceError.codeError("Unknown error")))
                    }
                }
            }
        }

        task = session
        session.resume()
    }


    private func makeRequestBody(nftIdArray: [String], token: String) -> URLRequest? {

        let profileRequest = ProfileRequest(id: "1")
        
        guard let url = profileRequest.endpoint else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var urlComponents = URLComponents(string: "\(url)")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "likes", value: "\(nftIdArray)")
        ]
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(String(describing: token))", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}
