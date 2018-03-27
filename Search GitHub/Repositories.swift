//
//  Repositories.swift
//  GitHubList
//
//  Created by eloysn on 21/3/18.
//

import Foundation


struct Repositories:Codable {
    
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
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.fullName = try container.decode(String.self, forKey: .fullName)
            self.id = try container.decode(Int.self, forKey: .id)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.owner = try container.decode(Owner.self, forKey: .owner)
            
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
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try container.decodeIfPresent(String.self, forKey: .login)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.ima = try container.decodeIfPresent(String.self, forKey: .ima)
    }
    
}

struct SearchItems: Codable {
    
    let items: [Repositories]
    
    private enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}







