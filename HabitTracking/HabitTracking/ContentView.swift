//
//  ContentView.swift
//  HabitTracking
//
//  Created by Daniel Kuroski on 02.12.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits = Habits()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { item in
                    Text(item.name)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let habits = Habits()
        habits.items.append(HabitItem(type: Type.build, name: "Get good night of rest", description: "My description", goal: 10))
        
        return ContentView(habits: habits)
    }
}
