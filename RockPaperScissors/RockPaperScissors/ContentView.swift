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
    
    var winDescription: String {
        switch self {
        case .rock:
            return "🪨 Rocks crush scissors."
        case .paper:
            return "📃 Paper covers rock."
        case .scissors:
            return "✂️ Scissors cut paper."
        }
    }
    
    var loseDescription: String {
        switch self {
        case .rock:
            return "📃 Paper covers rock."
        case .paper:
            return "✂️ Scissors cut paper."
        case .scissors:
            return "🪨 Rocks crush scissors."
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
    
    static func who(winAgainst opponentMove: Move) -> Move {
        return Move.allCases.first { (move) -> Bool in
            return move.does(winAgainst: opponentMove)
        }!
    }
    
    static func who(loseAgainst opponentMove: Move) -> Move {
        return Move.allCases.first { (move) -> Bool in
            return move.does(loseAgainst: opponentMove)
        }!
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
            Text(opponentMove.rawValue).font(.title)
            
            Text(shouldWin ? "Choose to win" : "Choose to lose")
                .padding(.vertical, 10)
            
            HStack(spacing: 30) {
                ForEach(Move.allCases, id: \.self) { move in
                    Button(move.rawValue, action: {
                        choice = Game(move: move)
                    })
                }
            }
        }.alert(item: $choice) { selectedChoice in
            let gotItRight = shouldWin ? selectedChoice.move.does(winAgainst: opponentMove) : selectedChoice.move.does(loseAgainst: opponentMove)
            
            print([shouldWin, gotItRight, selectedChoice.move.rawValue, opponentMove.rawValue])
            
            var message = shouldWin ? selectedChoice.move.winDescription : selectedChoice.move.loseDescription
            
            if !gotItRight {
                message = shouldWin ? Move.who(winAgainst: opponentMove).winDescription : Move.who(loseAgainst: opponentMove).loseDescription
            }
            
            return Alert(title: Text(gotItRight ? "Correct!" : "Wrong!"), message: Text(message), dismissButton: Alert.Button.default(Text("Continue"), action: {
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
