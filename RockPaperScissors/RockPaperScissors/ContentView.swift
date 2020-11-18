//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Daniel Kuroski on 17.11.20.
//

import SwiftUI

struct MoveView: View {
    var move: Move
    
    var body: some View {
        return Group {
            switch move {
            case .rock:
                Text("🪨")
            case .paper:
                Text("📃")
            case .scissors:
                Text("✂️")
            }
        }
    }
}

struct GoalView: View {
    var goal: Goal
    
    var body: some View {
        return HStack {
            Text("How to")
            switch goal {
            case .win:
                Text("WIN").foregroundColor(.green).fontWeight(.bold)
            case .lose:
                Text("LOSE").foregroundColor(.red).fontWeight(.bold)
            }
            Text("this game?")
        }.font(.title)
    }
}

struct ContentView: View {
    @State private var game = Game()
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            MoveView(move: game.opponentChoice)
                .font(.system(size: 100))
                .padding(20)
                .overlay(
                    Capsule(style: .circular)
                        .stroke(Color.gray, lineWidth: 3)
                )
            
            GoalView(goal: game.goal).padding(.vertical, 50)
            
            HStack(spacing: 30) {
                ForEach(Move.allCases, id: \.self) { move in
                    Button(action: { self.userAnswered(withMove: move) }) {
                        MoveView(move: move)
                            .padding()
                            .font(.system(size: 50))
                    }
                }
            }
        }.alert(isPresented: $showAlert) {
            let userWon = game.userWon ?? false
            let title = userWon ? "Correct!" : "Incorrect!"
            let description = userWon ? "Great, go to the next round." : "Sorry, but this is wrong."
            
            return Alert(
                title: Text(title),
                message: Text(description),
                dismissButton: Alert.Button.default(
                    Text("Continue"),
                    action: {
                        game = Game()
                        showAlert = false
                    }
                )
            )
        }
    }
    
    private func userAnswered(withMove move: Move) {
        let win = game.answer(withMove: move)
        self.showAlert = true
        print(win)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
