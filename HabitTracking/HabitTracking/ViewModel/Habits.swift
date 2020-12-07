//
//  Habit.swift
//  HabitTracking
//
//  Created by Daniel Kuroski on 02.12.20.
//

import SwiftUI

class Habits: ObservableObject {
    @Published var items: [HabitItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([HabitItem].self, from: items) {
                self.items = decoded
                return
            }
        }
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
