import Foundation

typealias CollectionNftCompletion = (Result<[CollectionNftModel], Error>) -> Void

protocol CollectionService {
    func loadCollection(completion: @escaping CollectionNftCompletion)
}

final class CollectionServiceImpl: CollectionService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCollection(completion: @escaping CollectionNftCompletion) {

        let request = CollectionRequest()

        networkClient.send(request: request) { result in
            do {
                switch result {
                case .success(let collection):
                    let decoder = JSONDecoder()
                    let collectionNftModels = try decoder.decode([CollectionNftModel].self, from: collection)
                    completion(.success(collectionNftModels))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
