import Foundation

typealias  RepositoriesResponse = [Repositories]

struct Repositories: Codable {
    let name: String
    let fullName: String
    let id: Int
    let description: String?
    let owner: Owner
    
    private enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case id
        case owner = "owner"
        case description = "description"
    }
}

struct Owner: Codable {

    let login: String?
    let type: String?
    let ima: String?

    private enum CodingKeys: String, CodingKey {
        case login
        case type
        case ima = "avatar_url"
    }
}
