//
//  User.swift
//  Friendface
//
//  Created by Daniel Kuroski on 14.12.20.
//

import Foundation

struct User: Decodable, Identifiable {
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
    
    struct Friend: Decodable, Identifiable {
        let id: String
        let name: String
        
        init(friend: CDFriend) {
            self.id = friend.wrappedId
            self.name = friend.wrappedName
        }
    }
    
    let friends: [Friend]
}

extension User {
    init(user: CDUser) {
        self.id = user.wrappedId
        self.isActive = user.isActive
        self.name = user.wrappedName
        self.age = user.wrappedAge
        self.company = user.wrappedCompany
        self.email = user.wrappedEmail
        self.address = user.wrappedAddress
        self.about = user.wrappedAbout
        self.registered = user.registered
        self.tags = user.wrappedTags
        self.friends = user.wrappedFriends.map({ Friend.init(friend: $0) })
    }
}
