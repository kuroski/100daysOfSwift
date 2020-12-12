//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Daniel Kuroski on 12.12.20.
//

import SwiftUI
import CoreData

struct WizardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Wizard.entity(), sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
    var body: some View {
        VStack {
            List(wizards, id: \.self) { wizard in
                Text(wizard.name ?? "Unknown")
            }
            
            Button("Add") {
                let wizard = Wizard(context: self.viewContext)
                wizard.name = "Harry Potter"
            }
            
            Button("Save") {
                do {
                    try self.viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ShipView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Ship.entity(), sortDescriptors: []) var ships: FetchedResults<Ship>
    
    @FetchRequest(entity: Ship.entity(), sortDescriptors: [], predicate: NSPredicate(format: "universe == 'Star Wars'")) var starWarsShips: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            Section(header: Text("Ships")) {
                List(ships, id: \.self) { ship in
                    Text(ship.name ?? "Unknown name")
                }
            }
            
            Section(header: Text("Star Wars ships")) {
                List(starWarsShips, id: \.self) { ship in
                    Text(ship.name ?? "Unknown name")
                }
            }
            
            Button("Add Examples") {
                let ship1 = Ship(context: self.viewContext)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"
                
                let ship2 = Ship(context: self.viewContext)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"
                
                let ship3 = Ship(context: self.viewContext)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"
                
                let ship4 = Ship(context: self.viewContext)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
                
                try? self.viewContext.save()
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Wizard", destination: WizardView())
                NavigationLink("Ship", destination: ShipView())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
