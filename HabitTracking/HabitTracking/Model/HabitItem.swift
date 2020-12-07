//
//  HabitItem.swift
//  HabitTracking
//
//  Created by Daniel Kuroski on 02.12.20.
//

import Foundation

enum Type: String, Codable {
    case build
    case quit
}

struct HabitItem: Identifiable, Codable {
    var id: String
    var type: Type
    var name: String
    var description: String
    var goal: Int?
    var days: [Bool?]
    var reward: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.type = try values.decode(Type.self, forKey: .type)
        self.name = try values.decode(String.self, forKey: .name)
        self.description = try values.decode(String.self, forKey: .description)
        self.goal = try? values.decode(Int.self, forKey: .goal)
        self.reward = try? values.decode(String.self, forKey: .reward)
        self.days = try values.decodeIfPresent([Bool?].self, forKey: .days) ?? Array(repeating: nil, count: 30)
        
        if (self.days.count != 30) {
            fatalError("Decoding Error!: Days array have a value of \(self.days.debugDescription)")
        }
    }
    
    var daysTried: Int {
        self.days.filter({ $0 != nil }).count
    }
    
    var finishedDays: Int {
        self.days.filter({ $0 == true }).count
    }
    
    var progress: Double {
        guard let goal = self.goal else { return 0.0 }
        if self.finishedDays > goal { return 1.0 }
        
        return Double(self.finishedDays) / Double(goal)
    }
    
    var isDone: Bool {
        self.daysTried == 30
    }
}
