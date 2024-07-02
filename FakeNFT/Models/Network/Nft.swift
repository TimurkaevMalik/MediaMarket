import Foundation

struct Nft: Decodable, Hashable {
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
    let author: URL
    let id: String
}
