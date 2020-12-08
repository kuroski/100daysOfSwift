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
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { item in
                    HabitCard(habit: item, changed: habits.toggleHabit, claimed: habits.claimHabit)
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
    let claimed: (String) -> Void
    
    var icon: String {
        switch habit.type {
        case .build:
            return "hammer"
        case .quit:
            return "scissors"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: icon)
                    Text(habit.name)
                        .font(.headline)
                    
                    if (habit.goal != nil && habit.reward == nil) {
                        Spacer()
                        ProgressBar(progress: habit.progress, color: .orange)
                    }
                }
                
                if let reward = habit.reward {
                    ProgressButton(reward: reward, claimed: habit.rewardClaimed, progress: habit.progress, action: { self.claimed(habit.id) })
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
    var color: Color = .green
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: thickness)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            if progress >= 1.0 {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
                    .foregroundColor(.orange)
                    .animation(.default)
            }
        }
        .frame(width: 20, height: 20)
    }
}

struct ProgressButton: View {
    let reward: String
    let claimed: Bool
    let progress: Double
    let action: () -> Void
    
    var hasGoalReached: Bool {
        progress >= 1.0
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.action()
            }
        }) {
            ZStack {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.gray.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                                .size(
                                    width: geometry.size.width * CGFloat(progress),
                                    height: geometry.size.height
                                )
                                .fill(hasGoalReached ? Color.orange : Color.gray)
                                .animation(.default)
                        )
                }
                HStack {
                    Spacer()
                    
                    Image(systemName: hasGoalReached ? "crown.fill" : "crown")
                    
                    
                    Text(reward)
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    if (claimed && hasGoalReached) {
                        Image(systemName: "checkmark.circle")
                            .animation(.default)
                    }
                }
                .foregroundColor(hasGoalReached ? .white : .black)
                .padding(.all, 10)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .modifier(Shake(animatableData: CGFloat(hasGoalReached ? 5 : 0)))
        .animation(hasGoalReached ? .default : .none)
        .disabled(!hasGoalReached)
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 1
    var animatableData: CGFloat
    
    var translationX: CGFloat {
        (amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)))
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: translationX, y: 0))
    }
}
