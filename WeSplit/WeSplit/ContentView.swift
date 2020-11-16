//
//  ContentView.swift
//  WeSplit
//
//  Created by Daniel Kuroski on 12.11.20.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages: [Int] = [10, 15, 20, 25, 0]
    
    var check: (perPerson: Double, total: Double) {
        let orderNumberOfPeople = Double(numberOfPeople) ?? 0
        let orderAmount = Double(checkAmount) ?? 0
        
        let peopleCount = Double(orderNumberOfPeople + 2)
        let tipSelection = Double(tipPercentages[tipPercentage])
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return (perPerson: amountPerPerson, total: grandTotal)
    }
    
    var isCheap: Bool {
        return tipPercentages[tipPercentage] == 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    TextField("Number of people", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total amount")) {
                    Text("$\(check.total, specifier: "%.2f")")
                        .proiminentTitle(color: isCheap ? .red : .blue)
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(check.perPerson, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit")
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
