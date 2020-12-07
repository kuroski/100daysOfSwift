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
    
    func toggleHabit(byId id: String, onDay index: Int) {
        guard let habitIndex = self.items.firstIndex(where: { $0.id == id }) else { return }
        
        let dayValue: [Bool?: Bool?] = [
            nil: true,
            true: false,
            false: nil
        ]
        self.items[habitIndex].days[index] = dayValue[self.items[habitIndex].days[index]] as? Bool
    }
}
