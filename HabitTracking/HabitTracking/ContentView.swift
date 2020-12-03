//
//  ContentView.swift
//  HabitTracking
//
//  Created by Daniel Kuroski on 02.12.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits: Habits = Habits()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { item in
                    Text(item.name)
                }
            }
            .navigationBarTitle(Text("30 days habit tracker"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        guard let url = Bundle.main.url(forResource: "habits.json", withExtension: nil) else {
            fatalError("Failed to locale habits.json fixture")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load habits.json file")
        }
        
        let decoder = JSONDecoder()
        guard let habitList: [HabitItem] = try? decoder.decode([HabitItem].self, from: data) else {
            fatalError("Failed to decode habits")
        }
        
        let habits = Habits()
        habits.items = habitList
        
        return ContentView(habits: habits)
    }
}
