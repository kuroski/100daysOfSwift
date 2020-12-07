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
                ForEach(habits.items) { item in
                    VStack {
                        HabitCard(habit: item, changed: habits.toggleHabit)
                    }
                }
                .onDelete(perform: habits.removeHabit)
                .padding(.vertical)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("30 days habit tracker"))
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddHabit = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(habits: self.habits)
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
    let changed: (String, Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text(habit.name)
                        .font(.headline)
                    
                    if (habit.goal != nil) {
                        Spacer()
                        ProgressBar(progress: habit.progress)
                    }
                }
                
                if let reward = habit.reward {
                    HStack {
                        Image(systemName: "gift")
                        Text(reward)
                    }.font(.subheadline)
                }
            }
            
            Spacer(minLength: 20)
            
            DailyProgress(days: habit.days, dayClicked: dayClicked)
        }
    }
    
    private func dayClicked(index: Int) {
        self.changed(habit.id, index)
    }
}

struct DailyProgress: View {
    var days: [Bool?]
    let dayClicked: (Int) -> Void
    
    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(days.indices) { index in
                Button(action: {
                    self.dayClicked(index)
                }) {
                    DayCircle(value: days[index], day: index + 1)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct DayCircle: View {
    var value: Bool?
    var day: Int
    
    private var color: (Color) {
        guard let dayValue = value else { return .gray }
        return dayValue ? .green : .red
    }
    
    var body: some View {
        Text(String(format: "%02d", day))
            .padding(.all, 10)
            .foregroundColor(color)
            .overlay(Circle().stroke(color, lineWidth: 2))
    }
}

struct ProgressBar: View {
    var progress: Double
    var thickness: CGFloat = 3.0
    
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
            
            //                Text("\(geometry.size.height)")
            
            //            Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
            //                .font(.caption)
            //                .foregroundColor(.green)
        }
        .frame(width: 20, height: 20)
    }
}
