import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func setProfile(body: [String], completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(completion: @escaping ProfileCompletion) {

        let request = GetLikesRequest()

        networkClient.send(request: request) { result in
            do {
                switch result {
                case .success(let data):
                    print()
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Profile.self, from: data)
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func setProfile(body: [String], completion: @escaping ProfileCompletion) {

        let request = SetLikesRequest(likes: body)

        networkClient.send(request: request) { result in
            do {
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Profile.self, from: data)
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
