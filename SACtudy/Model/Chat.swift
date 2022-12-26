//
//  Chat.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/02.
//

import Foundation
import RealmSwift

class Chat: EmbeddedObject, Codable {
    @Persisted var id: String
    @Persisted var content: String
    @Persisted var from: String
    @Persisted var to: String
    @Persisted var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content = "chat"
        case from,to,createdAt
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.content = try container.decode(String.self, forKey: .content)
        self.from = try container.decode(String.self, forKey: .from)
        self.to = try container.decode(String.self, forKey: .to)
        self.createdAt = try container.decode(String.self, forKey: .createdAt).toBirthDate ?? Date()
        
    }
}
