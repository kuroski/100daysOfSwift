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

struct SingerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var lastNameFilter = "A"
    
    var body: some View {
        VStack {
            FilteredList(
                filterKey: "lastName",
                filterValue: lastNameFilter,
                filterComparison: .beginsWith
            ) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            
            //            FilteredList(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
            //                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            //            }
            
            Button("Add Examples") {
                let taylor = Singer(context: self.viewContext)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: self.viewContext)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: self.viewContext)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? self.viewContext.save()
            }
            
            Button("Show A") {
                self.lastNameFilter = "A"
            }
            
            Button("Show S") {
                self.lastNameFilter = "S"
            }
        }
    }
}

struct CandyView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>
    
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(header: Text(country.wrappedFullName)) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            
            Button("Add") {
                let candy1 = Candy(context: self.viewContext)
                candy1.name = "Mars"
                candy1.origin = Country(context: self.viewContext)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"
                
                let candy2 = Candy(context: self.viewContext)
                candy2.name = "KitKat"
                candy2.origin = Country(context: self.viewContext)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"
                
                let candy3 = Candy(context: self.viewContext)
                candy3.name = "Twix"
                candy3.origin = Country(context: self.viewContext)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"
                
                let candy4 = Candy(context: self.viewContext)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: self.viewContext)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"
                
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
                NavigationLink("Singer", destination: SingerView())
                NavigationLink("Candy", destination: CandyView())
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
