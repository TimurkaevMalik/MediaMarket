import Foundation


final class StatisticNetworkServise {
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private let url: String = RequestConstants.baseURL
    private let token: String = RequestConstants.token
    
    // MARK: - Public Methods
    func fetchUsers(completion: @escaping (Result<Users, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode(Users.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(users))
                    }
                } catch let parsingError {
                    DispatchQueue.main.async {
                        completion(.failure(parsingError))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
    
    func fetchNft(id: String, completion: @escaping (Result<NftStatistic, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/nft/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let nft = try decoder.decode(NftStatistic.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(nft))
                    }
                } catch let parsingError {
                    DispatchQueue.main.async {
                        completion(.failure(parsingError))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
    
    func updateCart(ids: OrderStat, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/orders/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if !ids.nfts.isEmpty {
            let nftsString = ids.nfts.joined(separator: ",")
            let bodyString = "nfts=\(nftsString)"
            guard let bodyData = bodyString.data(using: .utf8) else { return }
            request.httpBody = bodyData
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
    
    func fetchCart(completion: @escaping (Result<OrderStat, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/orders/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let nfts = try decoder.decode(OrderStat.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(nfts))
                    }
                } catch let parsingError {
                    DispatchQueue.main.async {
                        completion(.failure(parsingError))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
    
    func fetchLike(completion: @escaping (Result<LikeStat, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/profile/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let nfts = try decoder.decode(LikeStat.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(nfts))
                    }
                } catch let parsingError {
                    DispatchQueue.main.async {
                        completion(.failure(parsingError))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
    
    func updateLike(ids: LikeStat, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/profile/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if !ids.likes.isEmpty {
            let nftsString = ids.likes.joined(separator: ",")
            let bodyString = "likes=\(nftsString)"
            guard let bodyData = bodyString.data(using: .utf8) else { return }
            request.httpBody = bodyData
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
}
