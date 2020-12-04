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
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.title2)
                            Spacer()
                            
                            if let reward = item.reward {
                                HStack {
                                    Image(systemName: "gift")
                                    Text(reward)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            if (item.goal != nil) {
                                Text("Goal").font(.caption)
                                Text(item.goalDescription)
                                
                                Spacer()
                            }
                            
                            
                            Text("Progress").font(.caption)
                            Text(item.progressDescription)
                        }
                    }
                }.padding(.vertical)
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
