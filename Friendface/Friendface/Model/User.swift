//
//  User.swift
//  Friendface
//
//  Created by Daniel Kuroski on 14.12.20.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date?
    let tags: [String]
    
    struct Friend: Codable, Identifiable {
        let id: String
        let name: String
    }
    
    let friends: [Friend]
}
