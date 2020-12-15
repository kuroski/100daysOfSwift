//
//  FriendfaceApp.swift
//  Friendface
//
//  Created by Daniel Kuroski on 14.12.20.
//

import SwiftUI

@main
struct FriendfaceApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
