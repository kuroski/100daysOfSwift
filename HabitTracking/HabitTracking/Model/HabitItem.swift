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
    let id: String
    let type: Type
    let name: String
    let description: String
    let goal: Int?
    let days: [Bool?]
    let reward: String?
    
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
    
    var goalDescription: String {
        if let goal = self.goal {
            if (daysTried > goal) { return "\(goal)/\(goal)" }
            return "\(daysTried)/\(goal)"
        }
        
        return "\(daysTried)/30"
    }
    
    var progressDescription: String {
        return "\(daysTried)/30"
    }
}
