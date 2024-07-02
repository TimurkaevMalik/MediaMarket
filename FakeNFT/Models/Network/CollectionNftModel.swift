import Foundation

struct CollectionNftModel: Decodable {
    let name: String
    let cover: URL
    let nfts: Set<UUID>
    let description: String
    let author: String
    let id: UUID
}
