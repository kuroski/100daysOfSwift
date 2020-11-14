//
//  ContentView.swift
//  ConvertTemperature
//
//  Created by Daniel Kuroski on 14.11.20.
//

import SwiftUI

enum Unit: String, CaseIterable {
    case celsius = "°C"
    case fahrenheit = "°F"
    case kelvin = "°K"
}

struct ContentView: View {
    @State private var temperature = "0.0"
    @State private var unit = Unit.celsius
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Unit", selection: $unit) {
                        ForEach(Unit.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Temperature")) {
                    TextField("Temperature", text: $temperature)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    HStack(alignment: .top, spacing: 0) {
                        Text("\(temperature) \(Unit.celsius.rawValue)")
                        Spacer()
                        Text("\(temperature) \(Unit.fahrenheit.rawValue)")
                        Spacer()
                        Text("\(temperature) \(Unit.kelvin.rawValue)")
                    }
                }
            }
            .navigationBarTitle("WeConvert")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
