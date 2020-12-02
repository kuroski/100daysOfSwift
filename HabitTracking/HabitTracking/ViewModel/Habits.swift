//
//  Habit.swift
//  HabitTracking
//
//  Created by Daniel Kuroski on 02.12.20.
//

import SwiftUI

class Habits: ObservableObject {
    @Published var items: [HabitItem]
    
    init() {
        self.items = []
    }
}
