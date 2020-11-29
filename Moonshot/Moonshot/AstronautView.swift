//
//  AstronautView.swift
//  Moonshot
//
//  Created by Daniel Kuroski on 29.11.20.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission]
    
    init(astronaut: Astronaut, missions: [Mission]) {
        self.astronaut = astronaut
        
        self.missions = missions.filter {
            $0.crew.contains {
                $0.name == astronaut.id
            }
        }
//        self.missions = missions.filter({ mission -> Bool in
//            mission.crew.contains(where: { $0.name == astronaut.name })
//        })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    Text("Missions").font(.title)
                    ForEach(self.missions) { mission in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(mission.displayName)
                                    .font(.headline)
                            }
                            
                            Spacer()
                        }.padding(.horizontal)
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[15], missions: missions)
    }
}
