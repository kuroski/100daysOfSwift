//
//  ProiminentTitleModifier.swift
//  WeSplit
//
//  Created by Daniel Kuroski on 16.11.20.
//

import SwiftUI

struct ProiminentTitleModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        let font = Font.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize).weight(.semibold)
        
        return content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func proiminentTitle(color: Color) -> some View {
        return self.modifier(ProiminentTitleModifier(color: color))
    }
}
