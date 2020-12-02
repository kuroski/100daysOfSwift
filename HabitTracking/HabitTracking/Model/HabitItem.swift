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
    var id = UUID()
    let type: Type
    let name: String
    let description: String
    let goal: Int?
}
