import Foundation

struct SetLikesRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Encodable?

    init(likes: [String]) {
        self.dto = likes.map { "likes=\($0)"}.joined(separator: "&").data(using: .utf8)
    }
}
