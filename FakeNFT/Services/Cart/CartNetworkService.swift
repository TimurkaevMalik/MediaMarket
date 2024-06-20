//
//  CartNetworkService.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 16.06.2024.
//

import Foundation

final class CartNetworkService {
    
    typealias OrderCompletion = (Result<OrderModel, Error>) -> Void
    typealias NFTCompletion = (Result<NftFromNetworkModel, Error>) -> Void
    typealias CurrenciesCompletion  = (Result<CurrenciesModel, Error>) -> Void
    typealias PaymentCompletion  = (Result<PaymentModel, Error>) -> Void
    
    private let url: String = RequestConstants.baseURL
    private let tocken: String = RequestConstants.token
    
    func fetchOrder(completion: @escaping OrderCompletion) {
        guard let url = URL(string: "https://\(self.url)/api/v1/orders/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.tocken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
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
                    let orderModel = try decoder.decode(OrderModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(orderModel))
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
    
    func requestByNftId(id: String, completion: @escaping NFTCompletion) {
        guard let url = URL(string: "https://\(self.url)/api/v1/nft/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.tocken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
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
                    let nft = try decoder.decode(NftFromNetworkModel.self, from: data)
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
    
    func requestCurrencies(completion: @escaping CurrenciesCompletion) {
        guard let url = URL(string: "https://\(self.url)/api/v1/currencies") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.tocken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
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
                    let currencyModel = try decoder.decode(CurrenciesModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(currencyModel))
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
    
    func requestPayment(completion: @escaping PaymentCompletion) {
        guard let url = URL(string: "https://\(self.url)/api/v1/orders/1/payment/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.tocken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
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
                    let paymentModel = try decoder.decode(PaymentModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(paymentModel))
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
}
