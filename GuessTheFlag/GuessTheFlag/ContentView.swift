//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Daniel Kuroski on 15.11.20.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var rotationDegrees = 0.0
    @State private var dimWrongFlags = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text(countries[correctAnswer]).fontWeight(.black)
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation(.spring()) {
                            self.rotationDegrees += 360.0
                            self.dimWrongFlags = true
                        }
                        
                        flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                    .rotation3DEffect(
                        .degrees(number == self.correctAnswer ? self.rotationDegrees : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(self.dimWrongFlags && number != self.correctAnswer ? 0.25 : 1.0)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text("Score: \(userScore)")
                        .foregroundColor(.white)
                }.padding()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 30
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showingScore = true
        }
    }
    
    func askQuestion() {
        rotationDegrees = 0.0
        dimWrongFlags = false
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
