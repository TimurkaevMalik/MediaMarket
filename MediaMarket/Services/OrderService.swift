import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    func loadOrder(completion: @escaping OrderCompletion)
    func updateOrder(body: [String], completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder(completion: @escaping OrderCompletion) {

        let request = OrderRequest()

        networkClient.send(request: request) { result in
            do {
                switch result {
                case .success(let data):
                    print()
                    let decoder = JSONDecoder()
                    let orderResponse = try decoder.decode(Order.self, from: data)
                    completion(.success(orderResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func updateOrder(body: [String], completion: @escaping OrderCompletion) {

        let request = PutOrderRequest(nfts: body)

        networkClient.send(request: request) { result in
            do {
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    let orderResponse = try decoder.decode(Order.self, from: data)
                    completion(.success(orderResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
