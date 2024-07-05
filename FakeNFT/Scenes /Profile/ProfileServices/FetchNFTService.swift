//
//  FetchNFTService.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 25.06.2024.
//

import Foundation

final class FetchNFTService {

    private(set) var nftResult: NFTResult?
    static let shared = FetchNFTService()

    private var task: URLSessionTask?

    private init() {}

    func fecthNFT(_ token: String, NFTId: String, completion: @escaping (Result<NFTResult, NetworkServiceError>) -> Void) {

        assert(Thread.isMainThread)

        if task != nil {
            task?.cancel()
        }

        guard let request = makeRequstBody(token: token, NFTId: NFTId) else {
            completion(.failure(NetworkServiceError.codeError("Uknown Error")))
            return
        }

        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            DispatchQueue.main.async { [weak self] in

                guard let self = self else {return}

                self.task = nil

                if let error = error {

                    completion(.failure(NetworkServiceError.codeError("Unknown error")))
                    return
                }

                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode  >= 300 {

                    completion(.failure(NetworkServiceError.responseError(response.statusCode)))
                    return
                }

                if let data = data {

                    do {
                        let nftResultInfo = try JSONDecoder().decode(NFTResult.self, from: data)

                        self.nftResult = nftResultInfo
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

    func makeRequstBody(token: String, NFTId: String) -> URLRequest? {

        let NFTRequest = NFTRequest(id: NFTId)

        guard let url = NFTRequest.endpoint,
              var urlComponents = URLComponents(string: "\(url)")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "nft_id", value: NFTId)
        ]

        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return nil
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(String(describing: token))", forHTTPHeaderField: "X-Practicum-Mobile-Token")

        return request
    }
}
