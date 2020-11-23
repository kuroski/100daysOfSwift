//
//  MultiplicationTablesApp.swift
//  MultiplicationTables
//
//  Created by Daniel Kuroski on 22.11.20.
//

import SwiftUI

@main
struct MultiplicationTablesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
