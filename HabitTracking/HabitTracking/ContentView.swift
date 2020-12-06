//
//  ContentView.swift
//  HabitTracking
//
//  Created by Daniel Kuroski on 02.12.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits: Habits = Habits()
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items, id: \.id) { item in
                    VStack {
                        HabitCard(habit: item)
                    }
                }.padding(.vertical)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("30 days habit tracker"))
            .navigationBarItems(trailing: Button(action: {
                self.showingAddHabit = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddHabit) {
                Text("TODO: Create add view")
            }
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

struct HabitCard: View {
    let habit: HabitItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .font(.headline)
                    
                    if let reward = habit.reward {
                        HStack {
                            Image(systemName: "gift")
                            Text(reward)
                        }.font(.subheadline)
                    }
                }
                
                if (habit.goal != nil) {
                    Spacer()
                    ProgressBar(progress: habit.progress)
                }
            }
            
            Spacer(minLength: 20)
            
            DailyProgress(days: habit.days)
        }
    }
}

struct DailyProgress: View {
    var days: [Bool?]
    
    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(days.indices) { index in
                Text(String(format: "%02d", index + 1))
                    .padding(.all, 10)
                    .overlay(
                        Circle()
                            .stroke(
                                days[index] == nil ? Color.gray
                                    : days[index]! ? Color.green
                                    : Color.red,
                                lineWidth: 2
                            )
                    )
            }
        }
    }
}

struct ProgressBar: View {
    var progress: Double
    var thickness: CGFloat = 4.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: thickness)
                .opacity(0.3)
                .foregroundColor(Color.green)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(String(format: "%.0f%", min(self.progress, 1.0) * 100.0))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.green)
        }
        .frame(width: 40, height: 40)
    }
}
