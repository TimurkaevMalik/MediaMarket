import Foundation

struct NftItem: Hashable, Codable {
    let id: UUID
    let name: String
    let rating: Int
    let price: Double
    let images: [URL]
    let isFavorite: Bool
}
