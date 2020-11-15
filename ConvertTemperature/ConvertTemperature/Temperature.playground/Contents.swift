import SwiftUI

var temperature = Measurement(value: 100, unit: UnitTemperature.celsius)
var convertedF = temperature.converted(to: .fahrenheit)
var convertedK = temperature.converted(to: .kelvin)

convertedF.description

var unitOptions: [UnitTemperature] = [.celsius, .fahrenheit, .kelvin]

var temperatureToConvert = "100.0"
var measurements: [Measurement<UnitTemperature>] {
    let measurement = Measurement(value: Double(temperatureToConvert) ?? 0, unit: unitOptions[0])
    
    return unitOptions.map { measurement.converted(to: $0) }
}

measurements
