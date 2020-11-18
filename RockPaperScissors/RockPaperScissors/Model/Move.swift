//
//  Move.swift
//  RockPaperScissors
//
//  Created by Daniel Kuroski on 17.11.20.
//

import Foundation

enum Move: String, CaseIterable {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
}

extension Move {
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

extension Move {
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
