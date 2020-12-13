//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Daniel Kuroski on 13.12.20.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var entities: FetchedResults<T> {
        fetchRequest.wrappedValue
    }
    
    let content: (T) -> Content
    
    var body: some View {
        List(entities, id: \.self) { entity in
            self.content(entity)
        }
    }
    
    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
}
