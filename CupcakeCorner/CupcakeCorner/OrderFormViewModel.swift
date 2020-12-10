//
//  Order.swift
//  CupcakeCorner
//
//  Created by Daniel Kuroski on 09.12.20.
//

import SwiftUI

class OrderFormViewModel: ObservableObject {
    @Published var order: Order
    
    init() {
        self.order = Order()
    }
}
