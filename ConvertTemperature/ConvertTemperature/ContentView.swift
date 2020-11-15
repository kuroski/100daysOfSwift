//
//  ContentView.swift
//  ConvertTemperature
//
//  Created by Daniel Kuroski on 14.11.20.
//

import SwiftUI

struct UnitOptions: Hashable {
    var unit: UnitTemperature
    var name: String
    
    static var celsius = UnitOptions(unit: .celsius, name: "Celsius")
    static var fahrenheit = UnitOptions(unit: .fahrenheit, name: "Fahrenheit")
    static var kelvin = UnitOptions(unit: .kelvin, name: "Kelvin")
}

struct ContentView: View {
    @State private var temperature = "100.0"
    @State private var selectedUnit = UnitOptions.celsius
    
    var unitOptions: [UnitOptions] = [.celsius, .fahrenheit, .kelvin]
    
    var measurements: [Measurement<UnitTemperature>] {
        let measurement = Measurement(value: Double(self.temperature) ?? 0, unit: self.selectedUnit.unit)
        
        return unitOptions
            .filter { $0.unit != self.selectedUnit.unit }
            .map { measurement.converted(to: $0.unit) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(unitOptions, id: \.self) {
                            Text($0.unit.symbol)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Temperature")) {
                    TextField("Temperature", text: $temperature)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Result")) {
                    ForEach(measurements, id: \.unit.symbol) { measure in
                        Text("\(measure.value, specifier: "%.2f") \(measure.unit.symbol)")
                    }
                }
            }
            .navigationBarTitle("WeConvert")
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
