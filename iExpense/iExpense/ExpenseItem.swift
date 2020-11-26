//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Daniel Kuroski on 26.11.20.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}
