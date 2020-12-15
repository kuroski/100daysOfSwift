//
//  CDFriend+CoreDataProperties.swift
//  Friendface
//
//  Created by Daniel Kuroski on 15.12.20.
//
//

import Foundation
import CoreData


extension CDFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFriend> {
        return NSFetchRequest<CDFriend>(entityName: "CDFriend")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var user: CDUser?
    
    var wrappedId: String {
        return id ?? UUID().uuidString
    }
    
    var wrappedName: String {
        return name ?? ""
    }

}

extension CDFriend : Identifiable {

}
