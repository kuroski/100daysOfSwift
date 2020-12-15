//
//  CDUser+CoreDataProperties.swift
//  Friendface
//
//  Created by Daniel Kuroski on 15.12.20.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var id: String?
    @NSManaged public var friends: NSSet?
    
    var wrappedId: String {
        return id ?? UUID().uuidString
    }
    
    var wrappedName: String {
        return name ?? ""
    }
    
    var wrappedAge: Int {
        return Int(age)
    }

    var wrappedCompany: String {
        return company ?? ""
    }

    var wrappedEmail: String {
        return email ?? ""
    }

    var wrappedAddress: String {
        return address ?? ""
    }
    
    var wrappedAbout: String {
        return about ?? ""
    }
    
    var wrappedTags: [String] {
        return tags?.components(separatedBy: ",") ?? []
    }
    
    var wrappedFriends: [CDFriend] {
        let set = friends as? Set<CDFriend> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for friends
extension CDUser {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: CDFriend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: CDFriend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension CDUser : Identifiable {

}
