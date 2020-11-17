//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Daniel Kuroski on 17.11.20.
//

import SwiftUI

enum Move: String, CaseIterable {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
    
    var howToWin: String {
        switch self {
        case .rock:
            return "Rocks crush scissors."
        case .paper:
            return "Paper covers rock."
        case .scissors:
            return "Scissors cut paper."
        }
    }
    
    var howToLose: String {
        switch self {
        case .rock:
            return "Paper covers rock."
        case .paper:
            return "Scissors cut paper."
        case .scissors:
            return "Rocks crush scissors."
        }
    }
    
    func does(winAgainst opponentMove: Move) -> Bool {
        switch self {
        case .rock:
            return opponentMove == .scissors
        case .paper:
            return opponentMove == .rock
        case .scissors:
            return opponentMove == .paper
        }
    }
    
    func does(loseAgainst opponentMove: Move) -> Bool {
        return self != opponentMove && opponentMove.does(winAgainst: self)
    }
}

struct Game: Identifiable {
    let id = UUID()
    var move: Move
}

struct ContentView: View {
    @State private var choice: Game?
    @State private var shouldWin = Bool.random()
    
    @State private var opponentMove = Move.allCases.randomElement()!
    
    var body: some View {
        VStack {
            Text(opponentMove.rawValue)
            
            Text(shouldWin ? "Choose to win" : "Choose to lose")
            
            HStack {
                ForEach(Move.allCases, id: \.self) { move in
                    Button(move.rawValue, action: {
                        choice = Game(move: move)
                    })
                }
            }
        }.alert(item: $choice) { selectedChoice in
            let gotItRight = shouldWin ? selectedChoice.move.does(winAgainst: opponentMove) : selectedChoice.move.does(loseAgainst: opponentMove)
            
            return Alert(title: Text(gotItRight ? "You win!" : "You lose!"), message: Text(shouldWin ? selectedChoice.move.howToWin : selectedChoice.move.howToLose), dismissButton: Alert.Button.default(Text("Continue"), action: {
                choice = nil
                shouldWin = Bool.random()
                opponentMove = Move.allCases.randomElement()!
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
