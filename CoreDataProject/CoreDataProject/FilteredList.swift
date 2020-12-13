//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Daniel Kuroski on 13.12.20.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    private var filterKey: String
    private var filterValue: String
    
    private var comparisonOperator: NSComparisonPredicate.Operator
    
    private var sortDescriptors: [NSSortDescriptor]
    
    var fetchRequest: FetchRequest<T>
    var buildListItem: (T) -> Content
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { entity in
            self.buildListItem(entity)
        }
    }
    
    init(
        filterKey: String,
        filterValue: String,
        filterComparison comparisonOperator: NSComparisonPredicate.Operator = .beginsWith,
        sortDescriptors: [NSSortDescriptor] = [],
        @ViewBuilder buildListItem: @escaping (T) -> Content
    ) {
        self.filterKey = filterKey
        self.filterValue = filterValue
        self.comparisonOperator = comparisonOperator
        self.sortDescriptors = sortDescriptors
        self.buildListItem = buildListItem
        
        let comparisonString = NSComparisonPredicate.stringValue(for: comparisonOperator)
        
        self.fetchRequest = .init(
            entity: T.entity(),
            sortDescriptors: sortDescriptors,
            predicate: NSPredicate(format: "%K \(comparisonString) %@", filterKey, filterValue),
            animation: nil
        )
    }
}
