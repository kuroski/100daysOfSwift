//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Daniel Kuroski on 12.12.20.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
