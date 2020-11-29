//
//  ContentView.swift
//  Moonshot
//
//  Created by Daniel Kuroski on 29.11.20.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var isDisplayingCrewNames = false
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts, missions: self.missions)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        
                        if (isDisplayingCrewNames) {
                            Text(mission.crewList)
                        } else {
                            Text(mission.formattedLaunchDate)
                        }
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing: Button(isDisplayingCrewNames ? "Show launch dates" : "Show crew") {
                self.isDisplayingCrewNames.toggle()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
