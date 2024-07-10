import Foundation

struct GetLikesRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        .get
    }
}
