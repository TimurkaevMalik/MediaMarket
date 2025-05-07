import Foundation

struct PutOrderRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Encodable?

    init(nfts: [String]) {
        self.dto = nfts.map { "nfts=\($0)"}.joined(separator: "&").data(using: .utf8)
    }
}
