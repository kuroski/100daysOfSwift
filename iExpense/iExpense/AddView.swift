//
//  AddView.swift
//  iExpense
//
//  Created by Daniel Kuroski on 26.11.20.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var hasError = false
    @State private var hasSubmitted = false
    
    @ObservedObject var expenses: Expenses
    @Environment(\.presentationMode) var presentationMode
    
    var isNameEmpty: Bool {
        self.hasSubmitted && self.name.isEmpty
    }
    
    var isAmountInvalid: Bool {
        self.hasSubmitted && (self.amount.isEmpty || Int(self.amount) == nil)
    }
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                if isNameEmpty {
                    Text("This field is required").font(.caption).foregroundColor(.red)
                }
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
                
                if isAmountInvalid {
                    Text("This field is required").font(.caption).foregroundColor(.red)
                }
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                                    Button("Save") {
                                        if let actualAmount = Int(self.amount) {
                                            let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                                            self.expenses.items.append(item)
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            self.hasError = true
                                            hasSubmitted = true
                                        }
                                    }
            )
        }
        .alert(isPresented: $hasError) {
            Alert(title: Text("Your form contains errors"), message: Text("Please fill in the form correctly"), dismissButton: .cancel())
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
