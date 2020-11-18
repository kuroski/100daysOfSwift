//
//  GameBrain.swift
//  RockPaperScissors
//
//  Created by Daniel Kuroski on 17.11.20.
//

import SwiftUI

struct Game: Identifiable {
    let id = UUID()
    let goal = Goal.allCases.randomElement()!
    let opponentChoice: Move = Move.allCases.randomElement()!
    
    var userWon: Bool? = nil
    
    mutating func answer(withMove userChoice: Move) -> Bool {
        switch self.goal {
        case .win:
            self.userWon = userChoice.does(winAgainst: opponentChoice)
        case .lose:
            self.userWon = userChoice.does(loseAgainst: opponentChoice)
        }
        
        return self.userWon!
    }
}
