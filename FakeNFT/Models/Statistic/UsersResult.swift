import Foundation


struct UsersResult: Decodable {
    let name: String
    let avatar: String?
    let rating: String
    let description: String
    let website: String
    let id: String
    let nfts: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case avatar
        case rating
        case description
        case website
        case id
        case nfts
    }
}
