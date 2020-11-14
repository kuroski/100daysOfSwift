//
//  ConvertTemperatureApp.swift
//  ConvertTemperature
//
//  Created by Daniel Kuroski on 14.11.20.
//

import SwiftUI

@main
struct ConvertTemperatureApp: App {
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
