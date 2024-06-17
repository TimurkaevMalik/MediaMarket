//
//  FetchProfileService.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 17.06.2024.
//

import UIKit

class FetchProfileService {
    
    static let shared = FetchProfileService()
    
    private var task: URLSessionTask?
    
    private init() {}
    
    private enum ProfileServiceError: Error {
        case codeError
        case responseError
        case invalidRequest
    }
    
    func fecthProfile(_ token: String, completion: @escaping (Result<ProfileResult,Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeRequstBody(token: token) else {
            completion(.failure(ProfileServiceError.codeError))
            return
        }
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else {return}
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode  >= 300 {
                    
                    print(response.statusCode)
                    completion(.failure(ProfileServiceError.responseError))
                    return
                }
                
                if let data = data {
                    
                    do {
                        let profileResultInfo = try JSONDecoder().decode(ProfileResult.self, from: data)
                        
                        completion(.success(profileResultInfo))
                    } catch {
                        completion(.failure(ProfileServiceError.codeError))
                    }
                }
                self.task = nil
            }
        }
        
        task = session
        session.resume()
    }
    
    func makeRequstBody(token: String) -> URLRequest? {
        
        let profileRequest = ProfileRequest(id: "1")
        
        guard let url = profileRequest.endpoint else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(String(describing: token))", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}
