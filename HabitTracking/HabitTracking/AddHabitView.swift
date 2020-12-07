//
//  AddHabitView.swift
//  HabitTracking
//
//  Created by Daniel Kuroski on 07.12.20.
//

import SwiftUI

struct AddHabitView: View {
    @State private var type = Type.build
    @State private var name = ""
    @State private var description = ""
    @State private var goal = 30
    @State private var reward = ""
    @State private var hasGoal = false
    @State private var hasValidationError = false
    
    @ObservedObject var habits: Habits
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Type")) {
                    Picker("Type", selection: $type) {
                        ForEach(Type.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Habit")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Reward", text: $reward)
                    Toggle("With goal of", isOn: $hasGoal.animation())
                    if (hasGoal) {
                        Stepper(value: $goal, in: 1...30, step: 1) {
                            if (goal == 1) {
                                Text("\(goal) day")
                            } else {
                                Text("\(goal) days")
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("Add new habit"))
            .navigationBarItems(trailing: Button("Save") {
                guard !self.name.isEmpty else { return self.hasValidationError = true }
                
                let habit = HabitItem(type: self.type, name: self.name, description: self.description, goal: self.hasGoal ? self.goal : nil, reward: self.reward.isEmpty ? nil : self.reward)
                
                self.habits.items.append(habit)
                self.presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $hasValidationError) {
                Alert(title: Text("The name field is required"), message: Text("Please, provide a name before continue"))
            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habits: Habits())
    }
}
