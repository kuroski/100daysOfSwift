//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Daniel Kuroski on 09.12.20.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var model: OrderFormViewModel
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $model.order.name)
                TextField("Street Address", text: $model.order.streetAddress)
                TextField("City", text: $model.order.city)
                TextField("Zip", text: $model.order.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(model: model)) {
                    Text("Check out")
                }
            }
            .disabled(!model.order.hasValidAddress)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(model: OrderFormViewModel())
    }
}
